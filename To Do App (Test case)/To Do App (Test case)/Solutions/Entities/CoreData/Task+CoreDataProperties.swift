//
//  Task+CoreDataProperties.swift
//  To Do App (Test case)
//
//  Created by Артур Миннушин on 24.11.2024.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var date: Date
    @NSManaged public var taskDescription: String
    @NSManaged public var isComplete: Bool

}

extension Task : Identifiable {

}
