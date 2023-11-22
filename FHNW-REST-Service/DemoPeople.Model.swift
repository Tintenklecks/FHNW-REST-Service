// Created 22.11.2023

import Foundation
extension DemoPeopleView {
    enum JSONPlaceholderAPI {
        case users
        case todo

        // MARK: Internal

        var url: URL {
            switch self {
            case .users:
                URL(string: "https://jsonplaceholder.typicode.com/users")!
            case .todo:
                URL(string: "https://jsonplaceholder.typicode.com/todos")!
            }
        }
    }
    
    enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
    
    class Model {
        func load(completion: @escaping (Users) -> Void) {
            let method = HTTPMethod.get
            let url = JSONPlaceholderAPI.users.url
            
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            
            let dataTask = URLSession.shared.dataTask( with:  request )  { data, response, error in
                if let error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let response,
                      let statusCode = (response as? HTTPURLResponse)?.statusCode,
                      (200 ..< 300).contains(statusCode)
                else {
                    print("HTTP Status is NOT 2xx")
                    return
                }
                
                guard let data else {
                    print("Data is empty")
                    return
                }
                
                let users = try! JSONDecoder().decode(Users.self, from: data)
                
                completion(users)
            }
            
            dataTask.resume()
        }
    }
}
