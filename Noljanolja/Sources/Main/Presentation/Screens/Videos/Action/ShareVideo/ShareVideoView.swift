//
//  ShareVideoView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 28/07/2023.
//
//

import SwiftUI

// MARK: - ShareVideoView

struct ShareVideoView<ViewModel: ShareVideoViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    // MARK: State

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildContentView()
            .navigationBarTitle("", displayMode: .inline)
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
    }

    private func buildContentView() -> some View {
        VStack(spacing: 8) {
            NavigationBarView(
                centerView: {
                    Text("Share")
                        .dynamicFont(.systemFont(ofSize: 14))
                }
            )
            .frame(height: 50)
            ContactListView(
                viewModel: ContactListViewModel(
                    isMultiSelectionEnabled: false,
                    isSearchHidden: true,
                    axis: .horizontal,
                    contactListUseCase: ContactListUseCaseImpl()
                ),
                selectedUsers: .constant([]),
                selectUserAction: {
                    viewModel.action.send($0)
                }
            )
        }
        .frame(maxWidth: .infinity)
    }
}
