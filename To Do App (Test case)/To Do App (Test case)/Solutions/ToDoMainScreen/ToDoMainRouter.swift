import Foundation
import UIKit

protocol ToDoMainRouterInput: AnyObject {
    func openDetailTaskScreenForCreate()
    func openDetailTaskScreenForChange(task: Task)
}

final class ToDoMainRouter: ToDoMainRouterInput {
    weak var view: UIViewController?
    
    func openDetailTaskScreenForCreate() {
        let createTaskView = ToDoDetailAssembly.buildScreenForNewTask()
        view?.navigationController?.pushViewController(createTaskView, animated: true)
    }
    
    func openDetailTaskScreenForChange(task: Task) {
        let changeTaskView = ToDoDetailAssembly.buildScreenForChangeTask(task: task)
        view?.navigationController?.pushViewController(changeTaskView, animated: true)
    }
}
