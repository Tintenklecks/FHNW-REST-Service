// Created 22.11.2023

import Foundation

// MARK: - HTTPMethod

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

// MARK: - RestService

class RestService {
    func load(method: HTTPMethod, url: URL, completion: @escaping (Data) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
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
            
            completion(data)
        }
        
        dataTask.resume()
    }
}
