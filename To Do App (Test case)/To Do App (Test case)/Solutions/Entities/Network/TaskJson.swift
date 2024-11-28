import Foundation

struct TaskJson: Decodable {
    let todos: [todos]
    struct todos: Decodable {
        let id: Int
        let todo: String
        let completed: Bool
        let userId: Int
    }
}

