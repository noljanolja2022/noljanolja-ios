//
//  CreateConversationContactListView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 06/03/2023.
//
//

import SDWebImageSwiftUI
import SwiftUI
import SwiftUINavigation

// MARK: - CreateConversationContactListView

struct CreateConversationContactListView<ViewModel: CreateConversationContactListViewModel>: View {
    // MARK: Dependencies

    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: ViewModel
    @State private var selectedUsers = [User]()

    private var isCreateConversationEnabled: Bool {
        !selectedUsers.isEmpty
    }

    var body: some View {
        buildBodyView()
            .navigationBar(backButtonTitle: "", isPresent: true, presentationMode: presentationMode, middle: { middle }, trailing: { trailing })
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .isProgressHUBVisible($viewModel.isProgressHUDShowing)
    }

    @ViewBuilder
    private func buildBodyView() -> some View {
        ContactListView(
            viewModel: ContactListViewModel(
                isMultiSelectionEnabled: {
                    switch viewModel.createConversationType {
                    case .single: return false
                    case .group: return true
                    case .unknown: return false
                    }
                }(),
                contactListUseCases: ContactListUseCasesImpl()
            ),
            selectedUsers: $selectedUsers,
            selectUserAction: { _ in
                switch viewModel.createConversationType {
                case .single:
                    viewModel.action.send(selectedUsers)
                case .group, .unknown:
                    return
                }
            }
        )
        .background(ColorAssets.neutralLight.swiftUIColor.ignoresSafeArea())
    }
    
    @ViewBuilder
    private var middle: some View {
        Text(
            { () -> String in
                switch viewModel.createConversationType {
                case .single, .unknown:
                    return L10n.contactsTitleNormal
                case .group:
                    return L10n.contactsTitleGroup
                }
            }()
        )
        .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
    }
    
    @ViewBuilder
    private var trailing: some View {
        ZStack {
            switch viewModel.createConversationType {
            case .single, .unknown:
                EmptyView()
            case .group:
                Button(L10n.commonAgree) {
                    viewModel.action.send(selectedUsers)
                }
                .dynamicFont(.systemFont(ofSize: 16))
                .foregroundColor(
                    isCreateConversationEnabled
                        ? ColorAssets.neutralDarkGrey.swiftUIColor
                        : ColorAssets.neutralGrey.swiftUIColor
                )
                .disabled(!isCreateConversationEnabled)
            }
        }
    }
}

// MARK: - CreateConversationContactListView_Previews

struct CreateConversationContactListView_Previews: PreviewProvider {
    static var previews: some View {
        CreateConversationContactListView(
            viewModel: CreateConversationContactListViewModel(
                createConversationType: .single
            )
        )
    }
}
