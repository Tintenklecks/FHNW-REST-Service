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

    class Model {
        func load() async throws -> Users {
            let service = RestService()
            let users = try await service
                .load(method: .get,
                      url: JSONPlaceholderAPI.users.url,
                      convertTo: Users.self)
            return users
        }

        func load(completion: @escaping (Users) -> Void) {
            let service = RestService()
            service.load(method: .get, url: JSONPlaceholderAPI.users.url, convertTo: Users.self) { users in
                completion(users)
            }
            service.load(method: .get, url: JSONPlaceholderAPI.todo.url, convertTo: Todos.self) { todos in
                print(todos)
            }
        }
    }
}
