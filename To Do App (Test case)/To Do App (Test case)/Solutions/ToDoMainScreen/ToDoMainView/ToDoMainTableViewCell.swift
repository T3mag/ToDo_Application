import UIKit

protocol ToDoMainTableViewCellDelegate {
    func updateStatusTask(indexPath: IndexPath, taskStatus: Bool)
}

final class ToDdMainTableViewCell: UITableViewCell {
    var taskStatus: Bool!
    var delegate: ToDoMainTableViewCellDelegate?
    let imageConfigure = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
    var superView: UITableView?
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 2
        label.textColor = UIColor(red: 134/256, green: 134/256, blue: 135/256, alpha: 1)
        return label
    }()
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 2
        label.textColor = UIColor(red: 134/256, green: 134/256, blue: 135/256, alpha: 1)
        return label
    }()
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = UIColor(red: 134/256, green: 134/256, blue: 135/256, alpha: 1)
        return label
    }()
    lazy var checkmarkButton: UIButton = {
        let button = UIButton()
        let action = UIAction { [weak self] _ in
            self?.changeStatusTask()
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        button.frame.size.width = 24
        button.frame.size.height = 24
        button.backgroundColor = .clear
        button.setImage(UIImage(systemName: "checkmark.circle", withConfiguration: imageConfigure), for: .normal)
        button.tintColor = UIColor(red: 254/256, green: 215/256, blue: 2/256, alpha: 1)
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = .black
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.isUserInteractionEnabled = false
        
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(dateLabel)
        addSubview(checkmarkButton)
        
        NSLayoutConstraint.activate([
            checkmarkButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            checkmarkButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: checkmarkButton.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 70),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: checkmarkButton.trailingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -12),
        ])
    }
    
    func getIndexPath() -> IndexPath {
        return superView?.indexPath(for: self) ?? IndexPath(row: 0, section: 0)
    }
    
    func setupStatusTask() {
        if !taskStatus {
            taskStatus = true
            checkmarkButton.setImage(UIImage(systemName: "circle",
                                             withConfiguration: imageConfigure),for: .normal)
            checkmarkButton.tintColor = UIColor(red: 134/256, green: 134/256, blue: 135/256, alpha: 1)
            titleLabel.textColor = .white
            dateLabel.textColor = .white
            descriptionLabel.textColor = .white
        } else {
            taskStatus = false
            checkmarkButton.setImage(UIImage(systemName: "checkmark.circle",
                                             withConfiguration: imageConfigure), for: .normal)
            checkmarkButton.tintColor = UIColor(red: 254/256, green: 215/256, blue: 2/256, alpha: 1)
            titleLabel.textColor = UIColor(red: 134/256, green: 134/256, blue: 135/256, alpha: 1)
            dateLabel.textColor = UIColor(red: 134/256, green: 134/256, blue: 135/256, alpha: 1)
            descriptionLabel.textColor = UIColor(red: 134/256, green: 134/256, blue: 135/256, alpha: 1)
        }
    }
    
    func setupCellInfo(taskTitle: String, taskDescrition: String, taskDate: Date, taskIsComplete: Bool) {
        titleLabel.text = taskTitle
        descriptionLabel.text = taskDescrition
        taskStatus = taskIsComplete
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let dateToString = dateFormatter.string(from: taskDate)
        dateLabel.text = dateToString
    }
    
    func changeStatusTask() {
        if !taskStatus {
            taskStatus = true
        } else {
            taskStatus = false
        }
        setupStatusTask()
        delegate?.updateStatusTask(indexPath: getIndexPath(), taskStatus: self.taskStatus)
    }
}
