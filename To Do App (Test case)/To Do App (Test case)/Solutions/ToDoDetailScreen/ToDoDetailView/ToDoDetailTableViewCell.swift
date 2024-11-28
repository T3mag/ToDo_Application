import UIKit

final class ToDoDetailTableViewCell: UITableViewCell {
    var textChanged: ((String) -> Void)?
    lazy var taskTitleTextfield: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = "Новая заметка"
        textField.textColor = .white
        textField.backgroundColor = .clear
        textField.font = UIFont.systemFont(ofSize: 34, weight: .heavy)
        return textField
    }()
    lazy var taskDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "22/10/2024"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(red: 134/256, green: 134/256, blue: 135/256, alpha: 1)
        label.backgroundColor = .clear
        return label
    }()
    lazy var taskDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.isEditable = true
        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textView.textColor = .white
        textView.text = "Составить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике."
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = false
        taskDescriptionTextView.delegate = self
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addSubview(taskTitleTextfield)
        addSubview(taskDateLabel)
        addSubview(taskDescriptionTextView)
        backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            taskTitleTextfield.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor, constant: 15),
            taskTitleTextfield.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            taskTitleTextfield.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            taskDateLabel.topAnchor.constraint(
                equalTo: taskTitleTextfield.bottomAnchor, constant: 10),
            taskDateLabel.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            
            taskDescriptionTextView.topAnchor.constraint(
                equalTo: taskDateLabel.bottomAnchor, constant: 15),
            taskDescriptionTextView.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 5),
            taskDescriptionTextView.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            taskDescriptionTextView.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupCell(title: String, date: String, description: String) {
        taskTitleTextfield.text = title
        taskDateLabel.text = date
        taskDescriptionTextView.text = description
    }
}

extension ToDoDetailTableViewCell: UITextViewDelegate {
    func textChanged(action: @escaping (String) -> Void) {
        self.textChanged = action
    }
        
    func textViewDidChange(_ textView: UITextView) {
        textChanged?(textView.text)
    }
}
