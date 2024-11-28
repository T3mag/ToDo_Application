import Foundation

protocol TasksMainInteractorInput: AnyObject {
    func getCurrentTasksInCoreData(completionHandler: @escaping(([Task]) -> Void))
    func deleteTask(taskId: UUID)
    func updateTaskStatus(taskId: UUID, indexPathTask: IndexPath, newStatus: Bool)
    func obtaineTaskFromApi()
    func checkIsFirtsStart() -> Bool
}

protocol TasksMainInteractorOutput: AnyObject {
    func reloadView()
    func updateCell(indexPathTask: IndexPath)
}

final class ToDoMainInteractor: TasksMainInteractorInput {
    private let backgroundQueue = DispatchQueue.global()
    private let coreData = CoreDataMangar.shared
    private let networkManger = NetworkManager.shared
    private let userDefauits = UserDefaults.standard
    weak var presenter: TasksMainInteractorOutput!
    
    func getCurrentTasksInCoreData(completionHandler: @escaping(([Task]) -> Void)) {
        backgroundQueue.async {
            completionHandler(self.coreData.obtaineSavedTasks())
        }
    }
    
    func deleteTask(taskId: UUID) {
        backgroundQueue.async {
            self.coreData.deleteTaskById(taskId: taskId)
            self.presenter.reloadView()
        }
    }
    
    func updateTaskStatus(taskId: UUID, indexPathTask: IndexPath, newStatus: Bool) {
        backgroundQueue.async {
            self.coreData.updateTaskStatusByid(taskId: taskId, newStatus: newStatus)
            self.presenter.updateCell(indexPathTask: indexPathTask)
        }
    }
    
    func obtaineTaskFromApi() {
        self.networkManger.fetchData(completionHandler: { result in
            switch result {
            case .success(let jsonResult):
                for task in jsonResult.todos {
                    self.coreData.addNewTasks(id: UUID(), title: task.todo,
                                              description: "Заметка",
                                              isCompleted: task.completed)
                }
                self.presenter.reloadView()
            case .failure(let error):
                print(error)
            }
            
        })
    }
    
    func checkIsFirtsStart() -> Bool {
        var checker = false
        if !userDefauits.bool(forKey: "first_start") {
            userDefauits.setValue(true, forKey: "first_start")
            checker = true
        }
        return checker
    }
}
