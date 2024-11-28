import Foundation
import UIKit

protocol ToDoDetailRouterInput: AnyObject {}

final class ToDoDetailRouter: ToDoDetailRouterInput {
    weak var view: UIViewController?
}

