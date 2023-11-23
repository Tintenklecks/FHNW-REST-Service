// Created 22.11.2023

import Foundation

extension DemoPeopleView {
    class ViewModel: ObservableObject {
        @Published var users: Users = []
        @Published var errorText: String = ""
        var model = Model()

        func update() {
            Task {
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

//        func update() {
//            model.load { users in
//                self.users = users
//            }
//        }
    }
}
