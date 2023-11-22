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

        func load(completion: (Users)->Void) {
            
            let method = HTTPMethod.get
            let url = JSONPlaceholderAPI.users.url
            
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let response,
                      let statusCode = (response as? HTTPURLResponse)?.statusCode,
                      statusCode == 200
                else {
                    print("HTTP Status is NOT 200")
                    return
                }
                
                guard let data else {
                    print("Data is empty")
                    return
                }
                
                
                
            }
        }
    }
}
