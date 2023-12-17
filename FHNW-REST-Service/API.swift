// Created 07.12.2023

import Foundation

// MARK: - ApiError

enum ApiError: Error {
    case invalidURL
}

// MARK: - JSONPlaceholderAPI

enum JSONPlaceholderAPI {
    case users
    case getUser
    case deleteUser
    case updateUser
    case todo

    var url: String {
        switch self {
        case .users:
            "https://jsonplaceholder.typicode.com/users"
        case .getUser:
            "https://jsonplaceholder.typicode.com/users/:id"
        case .deleteUser:
            "https://jsonplaceholder.typicode.com/users/:id"
        case .updateUser:
            "https://jsonplaceholder.typicode.com/users/:id"
        case .todo:
            "https://jsonplaceholder.typicode.com/todos"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .deleteUser: return .delete
        case .updateUser: return .put
        default: return .get
        }
    }
}
