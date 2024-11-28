import UIKit
import CoreData
import Combine

final class CoreDataMangar {
    static let shared = CoreDataMangar()
    var tasks: [Task] = []
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    var backgroundContext: NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
    
    init() { }
    
    public init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveBackgroundContext(context: NSManagedObjectContext) {
        do {
            try context.save()
            viewContext.performAndWait {
                do {
                    try viewContext.save()
                } catch {
                    print("Error when save viewContext: \(error)")
                }
            }
        } catch {
            print("Error when save backgroundContext: \(error)")
        }
    }
    
    func addNewTasks(id: UUID, title: String, description: String, isCompleted: Bool) {
        let context = backgroundContext
        return backgroundContext.performAndWait {
            let newTask = Task(context: context)
            newTask.title = title
            newTask.taskDescription = description
            newTask.date = Date()
            newTask.id = id
            newTask.isComplete = isCompleted
            self.saveBackgroundContext(context: context)
        }
    }
    
    func obtaineSavedTasks() -> [Task] {
        let videoFetchRequest = Task.fetchRequest()
        let sortDescriptors = NSSortDescriptor(key: "date", ascending: false)
        videoFetchRequest.sortDescriptors = [sortDescriptors]
        let result = try? self.viewContext.fetch(videoFetchRequest)
        return result ?? []
    }
    
    func deleteTaskById(taskId: UUID) {
        let context = backgroundContext
        return backgroundContext.perform {
            guard let task = self.obtaineSavedTasks().first(where: {$0.id == taskId}) else {
                fatalError()
            }
            let backgroundTask = context.object(with: task.objectID)
            context.delete(backgroundTask)
            self.saveBackgroundContext(context: context)
        }
    }
    
    func updateTaskStatusByid(taskId: UUID, newStatus: Bool) {
        let context = backgroundContext
        return backgroundContext.perform {
            guard let task = self.obtaineSavedTasks().first(where: {$0.id == taskId}) else {
                fatalError()
            }
            task.isComplete = newStatus
            self.saveBackgroundContext(context: context)
        }
    }
    
    func updateTaksInfoById(taskId: UUID, title: String, description: String) {
        let context = backgroundContext
        return backgroundContext.perform {
            guard let task = self.obtaineSavedTasks().first(where: {$0.id == taskId}) else {
                fatalError()
            }
            task.title = title
            task.taskDescription = description
            self.saveBackgroundContext(context: context)
        }
    }
}
