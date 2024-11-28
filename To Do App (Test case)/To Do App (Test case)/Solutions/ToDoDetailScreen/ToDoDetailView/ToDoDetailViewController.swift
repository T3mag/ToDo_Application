import UIKit

final class ToDoDetailViewController: UIViewController, ToDoPresenterOutput {
    private let tableViewConfigure = ToDoTableViewConfigure()
    private let contentView: ToDoDetailView = .init()
    var presenter: ToDoPresenterInput!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(task: Task) {
        super.init(nibName: nil, bundle: nil)
        tableViewConfigure.task = task
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        contentView.detailTableView.dataSource = tableViewConfigure
        navigationController?.navigationBar.tintColor = UIColor(red: 254/256, green: 215/256, blue: 2/256, alpha: 1)
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let cell: ToDoDetailTableViewCell = contentView.detailTableView.cellForRow(at: [0,0]) as! ToDoDetailTableViewCell
        if tableViewConfigure.task == nil {
            presenter.createNewTasks(title: cell.taskTitleTextfield.text ?? "",
                                     description: cell.taskDescriptionTextView.text ?? "",
                                     isComplete: false)
        } else {
            presenter.changeTaskInfo(id: tableViewConfigure.task?.id,
                                     title: cell.taskTitleTextfield.text ?? "",
                                     description: cell.taskDescriptionTextView.text ?? "")
        }
    }
}
