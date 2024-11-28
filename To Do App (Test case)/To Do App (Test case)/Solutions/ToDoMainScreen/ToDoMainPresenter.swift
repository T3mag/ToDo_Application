import Foundation

protocol ToDoMainPresenterInput: AnyObject {
    func openDetailTaskScreenForCreate()
    func openDetailTaskScreenForChange(task: Task)
    func getCurrentTasks(completionHandler: @escaping(([Task]) -> Void))
    func deleteTask(taskId: UUID)
    func updateTaskStatus(taskId: UUID, indexPathTask: IndexPath, newStatus: Bool)
    func obtaineTaskFromApi()
    func checkIsFirtsStart() -> Bool
}

protocol ToDoMainPresenterOutput: AnyObject {
    func reloadView()
    func updateCell(indexPathTask: IndexPath)
}

final class ToDoMainPresenter: ToDoMainPresenterInput, TasksMainInteractorOutput {
    var interactor: TasksMainInteractorInput!
    var router: ToDoMainRouterInput!
    weak var view: ToDoMainPresenterOutput?
    
    func openDetailTaskScreenForChange(task: Task) {
        router.openDetailTaskScreenForChange(task: task)
    }
    
    func openDetailTaskScreenForCreate() {
        router.openDetailTaskScreenForCreate()
    }
    
    func getCurrentTasks(completionHandler: @escaping(([Task]) -> Void)) {
        interactor.getCurrentTasksInCoreData(completionHandler: { tasks in
            completionHandler(tasks)
        })
    }
    
    func deleteTask(taskId: UUID) {
        interactor.deleteTask(taskId: taskId)
    }
    
    func updateCell(indexPathTask: IndexPath) {
        view?.updateCell(indexPathTask: indexPathTask)
    }
    
    func reloadView() {
        view?.reloadView()
    }
    
    func updateTaskStatus(taskId: UUID, indexPathTask: IndexPath, newStatus: Bool) {
        interactor.updateTaskStatus(taskId: taskId, indexPathTask: indexPathTask, newStatus: newStatus)
    }
    
    func obtaineTaskFromApi() {
        interactor.obtaineTaskFromApi()
    }
    
    func checkIsFirtsStart() -> Bool {
        return interactor.checkIsFirtsStart()
    }
}
