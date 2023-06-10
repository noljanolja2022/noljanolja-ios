//
//  FindUsersView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 07/06/2023.
//
//

import Combine
import SwiftUI

// MARK: - FindUsersView

struct FindUsersView<ViewModel: FindUsersViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    // MARK: State

    @EnvironmentObject private var progressHUBState: ProgressHUBState
    @EnvironmentObject private var alertStateObject: AlertStateObject<Void>

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildContentView()
            .navigationBarTitle("", displayMode: .inline)
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .onChange(of: viewModel.isProgressHUDShowing) {
                progressHUBState.isLoading = $0
            }
            .onReceive(viewModel.$alertState) {
                alertStateObject.alertState = $0
            }
    }

    private func buildContentView() -> some View {
        EmptyView()
    }
}

// MARK: - FindUsersView_Previews

struct FindUsersView_Previews: PreviewProvider {
    static var previews: some View {
        FindUsersView(
            viewModel: FindUsersViewModel(
                findUserModelTypePublisher: Empty<FindUsersModelType, Never>().eraseToAnyPublisher()
            )
        )
    }
}
