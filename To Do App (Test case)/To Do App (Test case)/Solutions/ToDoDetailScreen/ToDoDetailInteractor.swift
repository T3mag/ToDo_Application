import Foundation

protocol ToDoDetailInteractorInput: AnyObject {
    func createNewTask(title: String, description: String, isComplete: Bool)
    func changeTaskInfo(id: UUID?, title: String, description: String)
}

/// В моем проект Output интерактору не нужен, но решил оставить для полной реализации VIPER
protocol ToDoDetailInteractorOutput: AnyObject {}

final class ToDoDetailInteractor: ToDoDetailInteractorInput {
    private let backgroundQueue = DispatchQueue.global()
    private var coreData = CoreDataMangar.shared
    weak var presenter: ToDoDetailInteractorOutput!
    
    func createNewTask(title: String, description: String, isComplete: Bool) {
        backgroundQueue.async {
            self.coreData.addNewTasks(id: UUID(), title: title, description: description, isCompleted: isComplete)
        }
    }
    
    func changeTaskInfo(id: UUID?, title: String, description: String) {
        backgroundQueue.async {
            self.coreData.updateTaksInfoById(taskId: id!, title: title, description: description)
        }
    }
}
