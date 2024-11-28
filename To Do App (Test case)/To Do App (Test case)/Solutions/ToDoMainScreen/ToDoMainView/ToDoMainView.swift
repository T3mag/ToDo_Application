import UIKit

protocol ToDoMainViewDelegate: AnyObject {
    func openCreateTaskScreen()
    func reloadViewByFiltered(filterString: String)
}

final class ToDoMainView: UIView {
    var delegate: ToDoMainViewDelegate!
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 34, weight: .heavy)
        label.text = "Задачи"
        label.textColor = .white
        return label
    }()
    
    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor(red: 39/256, green: 39/256, blue: 41/256, alpha: 1)
        textField.layer.cornerRadius = 10
        textField.tintColor = UIColor(red: 134/256, green: 134/256, blue: 135/256, alpha: 1)
        textField.attributedPlaceholder = NSAttributedString(
            string: "Поиск",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 134/256, green: 134/256, blue: 135/256, alpha: 1)]
        )
        textField.textColor = .white
        textField.delegate = self

        let leftView = UIView(frame: CGRect(x: 20, y: 0, width: 35, height: 30))
        textField.leftView = leftView
        textField.leftViewMode = .always
        
        let leftImageView = UIImageView(frame: CGRect(x: 10, y: 7, width: 20, height: 17))
        leftImageView.image = UIImage(systemName: "magnifyingglass")
        leftView.addSubview(leftImageView)
        
        let rightView = UIView(frame: CGRect(x: 20, y: 0, width: 35, height: 30))
        textField.rightView = rightView
        textField.rightViewMode = .always
        
        let rightImageView = UIImageView(frame: CGRect(x: 10, y: 7, width: 13, height: 17))
        rightImageView.image = UIImage(systemName: "mic.fill")
        rightView.addSubview(rightImageView)
        
        return textField
    }()
    lazy var tasksTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(ToDdMainTableViewCell.self, forCellReuseIdentifier: "tasks")
        return tableView
    }()
    lazy var toolBarView: UIView = {
        let toolBarView = UIView()
        toolBarView.backgroundColor = UIColor(red: 39/256, green: 39/256, blue: 41/256, alpha: 1)
        toolBarView.translatesAutoresizingMaskIntoConstraints = false
        toolBarView.layer.borderColor = CGColor(red: 77/256, green: 85/256, blue: 94/256, alpha: 1)
        toolBarView.layer.borderWidth = 1
        return toolBarView
    }()
    lazy var newTaskButton: UIButton = {
        let button = UIButton()
        let imageConfigure = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "square.and.pencil", withConfiguration: imageConfigure), for: .normal)
        button.tintColor = UIColor(red: 254/256, green: 215/256, blue: 2/256, alpha: 1)
        
        let action = UIAction { [weak self] _ in
            self?.delegate.openCreateTaskScreen()
        }
        
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    lazy var counterTasksLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0 задач"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    func setupLayout() {
        addSubview(titleLabel)
        addSubview(searchTextField)
        addSubview(tasksTableView)
        addSubview(toolBarView)
        addSubview(newTaskButton)
        addSubview(counterTasksLabel)
        addSubview(counterTasksLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: -20),
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -15),

            searchTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            searchTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 15),
            searchTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -15),
            searchTextField.heightAnchor.constraint(equalToConstant: 36),
            
            tasksTableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 15),
            tasksTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 15),
            tasksTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -15),
            tasksTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            toolBarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -1),
            toolBarView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 1),
            toolBarView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 1),
            toolBarView.heightAnchor.constraint(equalToConstant: 100),
            
            newTaskButton.topAnchor.constraint(equalTo: toolBarView.topAnchor, constant: 18),
            newTaskButton.leadingAnchor.constraint(equalTo: toolBarView.trailingAnchor, constant: -50),
            
            counterTasksLabel.topAnchor.constraint(equalTo: toolBarView.topAnchor, constant: 30),
            counterTasksLabel.centerXAnchor.constraint(equalTo: toolBarView.centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ToDoMainView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        delegate.reloadViewByFiltered(filterString: textField.text ?? "")
        return true
    }
}
