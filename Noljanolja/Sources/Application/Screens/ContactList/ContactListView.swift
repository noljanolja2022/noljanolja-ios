//
//  ContactListView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 06/03/2023.
//
//

import SwiftUI
import SwiftUINavigation

// MARK: - ContactListView

struct ContactListView<ViewModel: ContactListViewModelType>: View {
    // MARK: Dependencies

    @StateObject private var viewModel: ViewModel

    // MARK: State

    init(viewModel: ViewModel = ContactListViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        buildContentView()
            .statefull(
                state: $viewModel.state.viewState,
                isEmpty: { viewModel.state.contactModels.isEmpty },
                loading: buildLoadingView,
                empty: buildEmptyView,
                error: buildErrorView
            )
            .onAppear {
                viewModel.send(.loadData)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Select country")
                        .font(FontFamily.NotoSans.bold.swiftUIFont(size: 18))
                        .foregroundColor(ColorAssets.forcegroundPrimary.swiftUIColor)
                }
            }
    }

    private func buildContentView() -> some View {
        List {
            ForEach(viewModel.state.contactModels, id: \.id) {
                ContactItemView(image: $0.image, name: $0.name)
            }
            .listRowInsets(EdgeInsets())
        }
        .listStyle(PlainListStyle())
    }

    private func buildLoadingView() -> some View {
        Text("Loading...")
    }

    private func buildErrorView() -> some View {
        IfLet($viewModel.state.error) {
            if let contactsError = $0.wrappedValue as? ContactsError,
               contactsError.isPermissionError {
                Text("error")
            } else {
                Text("Error")
            }
        }
    }

    private func buildEmptyView() -> some View {
        Text("Empty")
    }
}

// MARK: - ContactListView_Previews

struct ContactListView_Previews: PreviewProvider {
    static var previews: some View {
        ContactListView()
    }
}
