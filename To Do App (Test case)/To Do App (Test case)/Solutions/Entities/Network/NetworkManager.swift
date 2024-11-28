import Foundation
import Alamofire

final class NetworkManager {
    static let shared = NetworkManager()
    let jsonAPI = "https://dummyjson.com/todos"
    
    func fetchData(completionHandler: @escaping (Result<TaskJson, Error>) -> Void) {
        AF.request(jsonAPI)
            .validate()
            .responseJSON(queue: DispatchQueue.global()) { response in
                guard let data = response.data else {
                    if let error = response.error {
                        completionHandler(.failure(error))
                    }
                    return
                }
                let decoder = JSONDecoder()
                guard let userResults = try? decoder.decode(TaskJson.self, from: data) else {
                    fatalError()
                }
                completionHandler(.success(userResults))
            }
    }
}
