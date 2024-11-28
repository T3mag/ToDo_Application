import Foundation
import UIKit

final class ToDoDetailAssembly {
    static func buildScreenForNewTask() -> UIViewController {
        let view = ToDoDetailViewController()
        return setupScreenByView(view: view)
    }
    
    static func buildScreenForChangeTask(task: Task) -> UIViewController {
        let view = ToDoDetailViewController(task: task)
        return setupScreenByView(view: view)
    }
    
    private static func setupScreenByView(view: ToDoDetailViewController) -> UIViewController {
        let presenter = ToDoPresenter()
        let interactor = ToDoDetailInteractor()
        let router = ToDoDetailRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.view = view
        
        return view
    }
}
