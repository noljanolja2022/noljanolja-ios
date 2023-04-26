//
//  ChatSettingView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 07/04/2023.
//
//

import _SwiftUINavigationState
import SwiftUI

// MARK: - ChatSettingView

struct ChatSettingView<ViewModel: ChatSettingViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    // MARK: State

    @Environment(\.presentationMode) private var presentationMode
    
    @EnvironmentObject private var progressHUBState: ProgressHUBState

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        ZStack {
            buildContentView()
            buildNavigationLinks()
        }
        .navigationBarTitle("", displayMode: .inline)
        .onAppear { viewModel.isAppearSubject.send(true) }
        .onDisappear { viewModel.isAppearSubject.send(false) }
        .onChange(of: viewModel.isProgressHUDShowing) {
            progressHUBState.isLoading = $0
        }
        .onReceive(viewModel.closeAction) {
            presentationMode.wrappedValue.dismiss()
        }
        .alert(item: $viewModel.alertState) {
            Alert($0) { action in
                switch action {
                case let .removeParticipant(user):
                    viewModel.removeParticipantAction.send(user)
                case .leave:
                    viewModel.leaveAction.send()
                case .none:
                    break
                }
            }
        }
        .fullScreenCover(
            unwrapping: $viewModel.fullScreenCoverType,
            onDismiss: {
                viewModel.isPresentingSubject.send(false)
            },
            content: {
                switch $0.wrappedValue {
                case let .participantDetail(participantModel):
                    ParticipantDetailActionView(
                        viewModel: ParticipantDetailActionViewModel(
                            participantModel: participantModel,
                            delegate: viewModel
                        )
                    )
                    .introspectViewController {
                        $0.view.backgroundColor = .clear
                    }
                }
            }
        )
    }

    private func buildContentView() -> some View {
        ScrollView {
            VStack(spacing: 2) {
                buildMemberView()
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
                    let actions = participantModel.actionTypes
                    guard !actions.isEmpty else { return }
                    viewModel.fullScreenCoverType = .participantDetail(participantModel)
                }
            }
        }
        .padding(.bottom, 4)
        .background(ColorAssets.white.swiftUIColor)
    }

    @ViewBuilder
    private func buildSettingView() -> some View {
        if !viewModel.settingItems.isEmpty {
            VStack(spacing: 0) {
                Text("Settings")
                    .font(.system(size: 16, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 16)
                ForEach(viewModel.settingItems, id: \.self) { item in
                    buildSettingItemView(with: item)
                }
            }
            .padding(.top, 4)
            .background(ColorAssets.white.swiftUIColor)
        }
    }

    private func buildSettingItemView(with itemModel: ChatSettingItemModelType) -> some View {
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
            action: {
                viewModel.checkLeaveAction.send()
            },
            label: {
                Text("LEAVE CHAT ROOM")
                    .font(.system(size: 14, weight: .bold))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(12)
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
        NavigationLink(
            unwrapping: $viewModel.navigationType,
            onNavigate: { _ in },
            destination: { buildNavigationDestinationView($0) },
            label: { EmptyView() }
        )
        .isDetailLink(false)
    }

    @ViewBuilder
    private func buildNavigationDestinationView(
        _ type: Binding<ChatSettingNavigationType>
    ) -> some View {
        switch type.wrappedValue {
        case .contactList:
            UpdateConversationContactListView(
                viewModel: UpdateConversationContactListViewModel(
                    conversation: viewModel.conversationSubject.value
                )
            )
        case let .settingItem(settingItemModel):
            switch settingItemModel {
            case .updateTitle:
                ConversationTitleView(
                    viewModel: ConversationTitleViewModel(
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
