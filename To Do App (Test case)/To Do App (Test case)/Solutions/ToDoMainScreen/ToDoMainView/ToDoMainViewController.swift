import UIKit

protocol reloadedMainViewDelegate {
    func updateMainViewUI()
}

final class ToDoMainViewController: UIViewController, ToDoMainPresenterOutput {
    private let mainQueue = DispatchQueue.main
    private var tableViewConfigure = ToDoMainTableViewConfigure()
    private let contentView: ToDoMainView = .init()
    var presenter: ToDoMainPresenterInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        contentView.delegate = self
        tableViewConfigure.delegate = self
        contentView.tasksTableView.dataSource = tableViewConfigure
        contentView.tasksTableView.delegate = tableViewConfigure
        view = contentView
        if presenter.checkIsFirtsStart() {
            presenter.obtaineTaskFromApi()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadView()
    }
    
    func updateUI(tasks: [Task]) {
        mainQueue.sync {
            self.tableViewConfigure.tasks = tasks
            if tasks.count == 1 {
                self.contentView.counterTasksLabel.text = "\(tasks.count) задача"
            } else if tasks.count > 1 && tasks.count < 5 {
                self.contentView.counterTasksLabel.text = "\(tasks.count) задачи"
            } else {
                self.contentView.counterTasksLabel.text = "\(tasks.count) задач"
            }
            self.contentView.tasksTableView.reloadData()
        }
    }
    
    func reloadView() {
        mainQueue.async {
            self.presenter.getCurrentTasks(completionHandler: { tasks in
                self.updateUI(tasks: tasks)
            })
        }
    }
    
    func updateCell(indexPathTask: IndexPath) {
        mainQueue.async {
            self.contentView.tasksTableView.reloadRows(at: [indexPathTask], with: .automatic)
        }
    }
    
    func getTasks() -> [Task] {
        var tasksForReturn: [Task] = []
        presenter.getCurrentTasks(completionHandler: { tasks in
            tasksForReturn = tasks
        })
        return tasksForReturn
    }
    
    func obtaineTaskFromApi() {
        presenter.obtaineTaskFromApi()
    }
}

extension ToDoMainViewController: reloadedMainViewDelegate {
    func updateMainViewUI() {
        reloadView()
    }
}

extension ToDoMainViewController: ToDoMainViewDelegate {
    func reloadViewByFiltered(filterString: String) {
        if filterString == "" {
            presenter.getCurrentTasks(completionHandler: { tasks in
                self.updateUI(tasks: tasks)
            })
        } else {
            presenter.getCurrentTasks(completionHandler: { tasks in
                self.updateUI(tasks: tasks.filter { $0.title.contains(filterString) })
            })
        }
    }
    
    func openCreateTaskScreen() {
        presenter.openDetailTaskScreenForCreate()
    }
}

extension ToDoMainViewController: ToDoMainTableViewConfigureDelegate {
    func openDetailView(task: Task) {
        presenter.openDetailTaskScreenForChange(task: task)
    }
    
    func updateTaskStatus(taskId: UUID, indexPathTask: IndexPath, newStatus: Bool) {
        presenter.updateTaskStatus(taskId: taskId, indexPathTask: indexPathTask, newStatus: newStatus)
    }
    
    func deleteTask(taskId: UUID) {
        presenter.deleteTask(taskId: taskId)
    }
}


