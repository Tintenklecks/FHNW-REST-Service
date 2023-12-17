// Created 22.11.2023

import Foundation
extension DemoPeopleView {
    class Model {
        let service: RestService!
        
        private let defaultHeader: [String: String] = [
            "Content-Type": "application/json",
            //  "Authorization": "Bearer :YOUR_ACCESS_TOKEN",
            "User-Agent": "MyApp/1.0"
        ]
        
        init() {
            service = RestService(defaultHeader: defaultHeader)
        }
        
        // IN THE MODEL:
        
        func load() async throws -> Users {
            let users = try await service
                .get(url: JSONPlaceholderAPI.users.url, convertTo: Users.self)
            return users
        }
        
        func update(user: User) async throws {
            _ = try await service.request(
                method: JSONPlaceholderAPI.updateUser.method,
                url: JSONPlaceholderAPI.updateUser.url,
                convertTo: User.self,
                urlParameter: ["id": String(user.id)],
                body: user)
        }
    }
}
