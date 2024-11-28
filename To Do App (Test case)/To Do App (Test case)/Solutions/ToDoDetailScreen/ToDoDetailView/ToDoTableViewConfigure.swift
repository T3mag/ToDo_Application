import UIKit

final class ToDoTableViewConfigure: NSObject, UITableViewDataSource, UITableViewDelegate {
    var task: Task?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let taskCell = tableView.dequeueReusableCell(withIdentifier: "newOrEditTask", for: indexPath) as? ToDoDetailTableViewCell else { fatalError() }
        
        taskCell.taskTitleTextfield.text = task?.title ?? "Новая заметка"
        taskCell.taskDateLabel.text = "01/01/24"
        taskCell.taskDescriptionTextView.text = task?.taskDescription ?? "Новая заметка"
        
        taskCell.textChanged { [weak tableView] (_) in
            tableView?.beginUpdates()
            tableView?.endUpdates()
        }
        return taskCell
    }
}
