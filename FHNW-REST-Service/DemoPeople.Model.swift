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
        func load(completion: @escaping (Users) -> Void) {
            let service = RestService()
            service.load(method: .get, url: JSONPlaceholderAPI.users.url) { data in
                let users = try! JSONDecoder().decode(Users.self, from: data)

                completion(users)
            }

            service.load(method: .get, url: JSONPlaceholderAPI.todo.url) { data in
                let todos = try! JSONDecoder().decode(Todos.self, from: data)
                print(todos)
            }
        }
    }
}
