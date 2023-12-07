// Created 07.12.2023 

import Foundation

enum ApiError: Error {
    case invalidURL
}

enum JSONPlaceholderAPI {
    case users
    case deleteUser
    case todo

    var url: String {
        switch self {
        case .users:
            "https://jsonplaceholder.typicode.com/users"
        case .deleteUser:
            "https://jsonplaceholder.typicode.com/users/:id"
        case .todo:
            "https://jsonplaceholder.typicode.com/todos"
        }
    }

    private var defaultHeader: [String: String] {
        [
            "Content-Type": "application/json",
            "Authorization": "Bearer :YOUR_ACCESS_TOKEN",
            "User-Agent": "MyApp/1.0"
        ]
    }

    func header(with headerParameter: [String: String] = [:], replacing keyValues: [String: String] = [:]) -> [String: String] {
        var combinedHeaders = defaultHeader
        combinedHeaders.merge(headerParameter) { _, new in new }

        return combinedHeaders
    }

    func url(replacing keyValues: [String: String] = [:]) throws -> URL {
        var currentURL = url
        for parameter in keyValues {
            currentURL = currentURL.replacingOccurrences(of: ":\(parameter.key)", with: parameter.value)
        }
        guard let url = URL(string: currentURL) else {
            throw ApiError.invalidURL
        }
        return url
    }

    var method: HTTPMethod {
        switch self {
        case .deleteUser: return .delete
        default: return .get
        }
    }
}
