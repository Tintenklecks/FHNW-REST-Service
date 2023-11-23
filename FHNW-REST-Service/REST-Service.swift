// Created 22.11.2023

import Foundation

// MARK: - HTTPMethod

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

// MARK: - NetworkError

public enum NetworkError: Error, Equatable {
    case badURL
    case apiError(code: Int)
    case invalidJSON
    case serverError(code: Int)
    case unableToParseData
    case thrownError(error: String)
    
    // MARK: Public

    public var description: String {
        switch self {
        case .badURL: return "ERROR: Invalid url!"
        case .apiError(let code): return "ERROR: API failed with code \(code)"
        case .invalidJSON: return "ERROR: Invalid json file!"
        case .serverError(let code): return "ERROR: Server failed with code:\(code)"
        case .unableToParseData: return "ERROR: Unable to parse data!"
        case .thrownError(let error): return "ERROR: \(error)"
        }
    }
}

// MARK: - RestService

class RestService {
    func load<T: Codable>(method: HTTPMethod, url: URL, convertTo type: T.Type) async throws -> T {
        var request = URLRequest(url: url, timeoutInterval: 2)
        request.httpMethod = method.rawValue
        
        let (data, response) = try await URLSession.shared.data(from: url)
        if let statusCode = (response as? HTTPURLResponse)?.statusCode,
           statusCode >= 300
        {
            throw NetworkError.serverError(code: statusCode)
        }
        
        return try JSONDecoder().decode(type.self, from: data)
    }
    
    func load<T: Codable>(method: HTTPMethod, url: URL, convertTo type: T.Type, completion: @escaping (T) -> Void) {
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
            guard let result = try? JSONDecoder().decode(type.self, from: data) else {
                print("Data cant be converted")
                return
            }
        
            completion(result)
        }
    
        dataTask.resume()
    }
}
