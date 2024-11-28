import UIKit

protocol ToDoMainTableViewConfigureDelegate: AnyObject {
    func deleteTask(taskId: UUID)
    func updateTaskStatus(taskId: UUID, indexPathTask: IndexPath, newStatus: Bool)
    func openDetailView(task: Task)
}

final class ToDoMainTableViewConfigure: NSObject, UITableViewDataSource, UITableViewDelegate {
    var tasks: [Task] = []
    var delegate: ToDoMainTableViewConfigureDelegate?
    
    func setTasksList(tasks: [Task]) {
        self.tasks = tasks
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let taskCell = tableView.dequeueReusableCell(withIdentifier: "tasks",
                                                           for: indexPath) as? ToDdMainTableViewCell else { fatalError() }
        let task: Task = tasks[indexPath.row]
        taskCell.setupCellInfo(taskTitle: task.title, taskDescrition: task.taskDescription,
                               taskDate: task.date, taskIsComplete: task.isComplete)
        taskCell.superView = tableView
        taskCell.delegate = self
        taskCell.setupStatusTask()
        return taskCell
    }
    
    func tableView(_ tableView: UITableView,
                            contextMenuConfigurationForRowAt indexPath: IndexPath,
                            point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
            let inspectAction =
                UIAction(title: NSLocalizedString("Изменить", comment: ""),
                         image: UIImage(systemName: "square.and.pencil")) { action in
                    self.delegate?.openDetailView(task: self.tasks[indexPath.row])
                }
            
            let shareAction = UIAction(title: NSLocalizedString("Отправить", comment: ""),
                        image: UIImage(systemName: "square.and.arrow.up")) { action in
                }
            
            let deleteAction =
                UIAction(title: NSLocalizedString("Удалить", comment: ""),
                         image: UIImage(systemName: "trash"), attributes: .destructive) { action in
                    self.delegate?.deleteTask(taskId: self.tasks[indexPath.row].id)
                }
            
            return UIMenu(title: "", children: [inspectAction, shareAction, deleteAction])
        })
    }
}

extension ToDoMainTableViewConfigure: ToDoMainTableViewCellDelegate {
    func updateStatusTask(indexPath: IndexPath, taskStatus: Bool) {
        let task = tasks[indexPath.row]
        delegate?.updateTaskStatus(taskId: task.id, indexPathTask: indexPath, newStatus: taskStatus)
    }
}
