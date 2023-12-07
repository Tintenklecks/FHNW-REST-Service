// Created 22.11.2023

import Foundation
extension DemoPeopleView {

    class Model {
        func load() async throws -> Users {
            let service = RestService()
            let users = try await service
                .load(method: .get,
                      url: JSONPlaceholderAPI.deleteUser.url(),
                      convertTo: Users.self)
            return users
        }
    }
}
