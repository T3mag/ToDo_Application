import Foundation
import UIKit

final class ToDoMainAssembly {
    static func buildScreen() -> UIViewController {
        let view = ToDoMainViewController()
        let presenter = ToDoMainPresenter()
        let interactor = ToDoMainInteractor()
        let router = ToDoMainRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.view = view
        
        return view
    }
}
