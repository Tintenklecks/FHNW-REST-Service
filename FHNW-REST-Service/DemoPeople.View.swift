// Created 22.11.2023

import SwiftUI

// MARK: - DemoPeopleView

struct DemoPeopleView: View {
    @StateObject var viewModel = ViewModel(restService: RestService())

    var body: some View {
        VStack(alignment: .leading) {
            if !viewModel.errorText.isEmpty {
                HStack {
                    Text(viewModel.errorText)
                }
                .padding(30)
                .background(Color.red)
            }
            Text("User").font(.largeTitle)
            Divider()
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(viewModel.users) { user in
                        Text(user.name).font(.headline)
                            .padding()
                            .background(
                                Color.white

                                    .shadow(radius: 4)
                            )
                            .padding()
                    }
                }
            }
            .refreshable {
                Task {
                   await viewModel.update()
                }
            }

            Spacer()
        }
        .padding()
        .task {
           await viewModel.update()
        }
    }
}

// MARK: - User + Identifiable

extension User: Identifiable {}

#Preview {
    let viewModel = DemoPeopleView.ViewModel(restService: LocalJsonService())

    return DemoPeopleView(viewModel: viewModel)
}
