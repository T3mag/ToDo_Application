import Foundation
import UIKit

protocol ToDoPresenterInput: AnyObject {
    func createNewTasks(title: String, description: String, isComplete: Bool)
    func changeTaskInfo(id: UUID?, title: String, description: String)
}

/// В моем проект Output презентору не нужен, но решил оставить для полной реализации VIPER
protocol ToDoPresenterOutput: AnyObject {}

final class ToDoPresenter: ToDoPresenterInput, ToDoDetailInteractorOutput {
    var interactor: ToDoDetailInteractorInput!
    var router: ToDoDetailRouterInput!
    weak var view: ToDoPresenterOutput?
    
    func createNewTasks(title: String, description: String, isComplete: Bool) {
        interactor.createNewTask(title: title, description: description, isComplete: isComplete)
    }
    
    func changeTaskInfo(id: UUID?, title: String, description: String) {
        interactor.changeTaskInfo(id: id, title: title, description: description)
    }
}
