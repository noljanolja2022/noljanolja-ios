//
//  ChatSettingView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 07/04/2023.
//
//

import SwiftUI

// MARK: - ChatSettingView

struct ChatSettingView<ViewModel: ChatSettingViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        ZStack {
            buildContentView()
            buildNavigationLinks()
        }
        .onAppear { viewModel.isAppearSubject.send(true) }
        .onDisappear { viewModel.isAppearSubject.send(false) }
        .fullScreenCover(unwrapping: $viewModel.fullScreenCoverType) {
            switch $0.wrappedValue {
            case let .userDetail(participantModel):
                ChatSettingParticipantDetailView(
                    viewModel: ChatSettingParticipantDetailViewModel(
                        participantModel: participantModel
                    )
                )
                .introspectViewController {
                    $0.view.backgroundColor = .clear
                }
            }
        }
    }

    private func buildContentView() -> some View {
        ScrollView {
            VStack(spacing: 0) {
                buildMemberView()
                Text("")
                    .frame(height: 2)
                    .frame(maxWidth: .infinity)
                    .background(ColorAssets.neutralLightGrey.swiftUIColor)
                    .padding(.vertical, 4)
                    .background(ColorAssets.white.swiftUIColor)
                buildSettingView()
                buildLeaveView()
            }
        }
        .background(
            ColorAssets.neutralLightGrey.swiftUIColor
                .edgesIgnoringSafeArea(.bottom)
        )
    }

    private func buildMemberView() -> some View {
        VStack(spacing: 0) {
            Text("Members")
                .font(.system(size: 16, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 10)
                .padding(.horizontal, 16)

            if viewModel.isAddParticipantsEnabled {
                ChatSettingAddParticipantView()
                    .padding(.vertical, 10)
                    .padding(.horizontal, 16)
                    .onTapGesture {
                        viewModel.navigationType = .contactList
                    }
            }

            ForEach(viewModel.participantModels.indices, id: \.self) { index in
                let participantModel = viewModel.participantModels[index]
                ChatSettingParticipantItemView(
                    model: participantModel
                )
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .background(ColorAssets.white.swiftUIColor)
                .onTapGesture {
                    let actions = participantModel.chatSettingUserDetailActions
                    guard !actions.isEmpty else { return }
                    viewModel.fullScreenCoverType = .userDetail(participantModel)
                }
            }
        }
        .background(ColorAssets.white.swiftUIColor)
    }

    private func buildSettingView() -> some View {
        VStack(spacing: 0) {
            Text("Settings")
                .font(.system(size: 16, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
            buildSettingItemView(with: .updateTitle)
        }
        .background(ColorAssets.white.swiftUIColor)
    }

    private func buildSettingItemView(with itemModel: ChatSettingItemModel) -> some View {
        VStack(spacing: 0) {
            ChatSettingItemView(itemModel: itemModel)
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
            Divider()
                .frame(height: 2)
                .overlay(ColorAssets.neutralLightGrey.swiftUIColor)
        }
        .onTapGesture {
            viewModel.navigationType = .settingItem(itemModel)
        }
    }

    private func buildLeaveView() -> some View {
        Button(
            action: {},
            label: {
                Text("LEAVE CHAT ROOM")
                    .font(.system(size: 14, weight: .bold))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(10)
                    .foregroundColor(ColorAssets.red.swiftUIColor)
                    .background(ColorAssets.white.swiftUIColor)
                    .cornerRadius(4)
            }
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(16)
    }

    @ViewBuilder
    private func buildNavigationLinks() -> some View {
        ZStack {
            NavigationLink(
                unwrapping: $viewModel.navigationType,
                onNavigate: { _ in },
                destination: { buildNavigationDestinationView($0) },
                label: { EmptyView() }
            )
        }
    }

    @ViewBuilder
    private func buildNavigationDestinationView(
        _ navigationType: Binding<ChatSettingNavigationType>
    ) -> some View {
        switch navigationType.wrappedValue {
        case .contactList:
            UpdateConversationContactListView(
                viewModel: UpdateConversationContactListViewModel(
                    conversation: viewModel.conversationSubject.value
                )
            )
        case let .settingItem(settingItemModel):
            switch settingItemModel {
            case .updateTitle:
                ChatSettingUpdateTitleView(
                    viewModel: ChatSettingUpdateTitleViewModel(
                        conversation: viewModel.conversationSubject.value
                    )
                )
            }
        }
    }
}

// MARK: - ChatSettingView_Previews

struct ChatSettingView_Previews: PreviewProvider {
    static var previews: some View {
        ChatSettingView(
            viewModel: ChatSettingViewModel(
                conversation: Conversation(
                    id: 0,
                    title: nil,
                    creator: User(
                        id: "",
                        name: nil,
                        avatar: nil,
                        pushToken: nil,
                        phone: nil,
                        email: nil,
                        isEmailVerified: false,
                        dob: nil,
                        gender: nil,
                        preferences: nil,
                        createdAt: Date(),
                        updatedAt: Date()
                    ),
                    admin: User(
                        id: "",
                        name: nil,
                        avatar: nil,
                        pushToken: nil,
                        phone: nil,
                        email: nil,
                        isEmailVerified: false,
                        dob: nil,
                        gender: nil,
                        preferences: nil,
                        createdAt: Date(),
                        updatedAt: Date()
                    ),
                    type: .single,
                    messages: [],
                    participants: [],
                    createdAt: Date(),
                    updatedAt: Date()
                )
            )
        )
    }
}
