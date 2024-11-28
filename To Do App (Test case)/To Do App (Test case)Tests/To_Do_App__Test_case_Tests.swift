//
//  To_Do_App__Test_case_Tests.swift
//  To Do App (Test case)Tests
//
//  Created by Артур Миннушин on 20.11.2024.
//

import XCTest
@testable import To_Do_App__Test_case_
import CoreData

final class To_Do_App__Test_case_Tests: XCTestCase {
    var coreDataManager: CoreDataMangar!
    
    override func setUpWithError() throws {
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            container.viewContext.automaticallyMergesChangesFromParent = true
            if let error = error as NSError? {
                XCTAssertNil(error, "Failed to load CoreData stack: \(error.localizedDescription)")
            }
        })
        coreDataManager = CoreDataMangar(persistentContainer: container)
    }

    func createTestTask() -> UUID {
        let testTaskTitle = "TestTitile"
        let testTaskDescription = "TestDescription"
        let testTaskIsComplete = false
        let testUUID = UUID()
        
        coreDataManager.addNewTasks(id: testUUID,
                                    title: testTaskTitle,
                                    description: testTaskDescription,
                                    isCompleted: testTaskIsComplete)
        return testUUID
    }
    
    func test_Add_Tasks_Success() throws {
        //GIVEM
        let currentTasksCount = coreDataManager.obtaineSavedTasks().count
        let testTaskTitle = "TestTitle"
        let testTaskDescription = "TestDescription"
        let testTaskIsComplete = false
        let testUUID = UUID()
        //WHEN
        coreDataManager.addNewTasks(id: testUUID,
                                    title: testTaskTitle,
                                    description: testTaskDescription,
                                    isCompleted: testTaskIsComplete)
        //THEN
        XCTAssertEqual(coreDataManager.obtaineSavedTasks().count - currentTasksCount, 1)
    }
    
    func test_delete_Data_Success() throws {
        //GIVEN
        let testTaskId = createTestTask()
        let currentTaksCount = coreDataManager.obtaineSavedTasks().count
        //WHEN
        coreDataManager.deleteTaskById(taskId: testTaskId)
        //THEN
        XCTAssertEqual(coreDataManager.obtaineSavedTasks().count - currentTaksCount, 0)
    }
    
    func test_update_TaskStatus_Success() throws {
        //GIVEN
        let testTaskId = createTestTask()
        //WHEN
        coreDataManager.updateTaskStatusByid(taskId: testTaskId, newStatus: true)
        //THEN
        let updatedTasks = coreDataManager.obtaineSavedTasks().first(where: { $0.id == testTaskId})
        XCTAssertTrue(((updatedTasks?.isComplete) != nil))
    }
}
