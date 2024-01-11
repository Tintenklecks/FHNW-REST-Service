// Created 22.11.2023

import Foundation

extension DemoPeopleView {
    class ViewModel: ObservableObject {
        @Published var users: Users = []
        @Published var errorText: String = ""
        var model: Model

        
        init(restService: RestServiceProtocol) {
            model = Model(restService: restService)
        }

        func update() async {
            do {
                let users = try await model.load()
                DispatchQueue.main.async {
                    self.users = users
                    self.errorText = ""
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorText = error.localizedDescription
                }
            }
        }
    }
}
