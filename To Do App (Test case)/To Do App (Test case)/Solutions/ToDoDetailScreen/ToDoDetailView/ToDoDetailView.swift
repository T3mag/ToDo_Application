//
//  ToDoDetailView.swift
//  To Do App (Test case)
//
//  Created by Артур Миннушин on 22.11.2024.
//

import UIKit

final class ToDoDetailView: UIView {
    lazy var detailTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(ToDoDetailTableViewCell.self, forCellReuseIdentifier: "newOrEditTask")
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addSubview(detailTableView)
        NSLayoutConstraint.activate([
            detailTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            detailTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            detailTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            detailTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
