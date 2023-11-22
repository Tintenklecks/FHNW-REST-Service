// Created 22.11.2023

import Foundation

extension DemoPeopleView {
    class ViewModel: ObservableObject {
        @Published var users: Users = []
        var model = Model()

        func update() {
            model.load { users in
                self.users = users
            }
        }
    }
}
