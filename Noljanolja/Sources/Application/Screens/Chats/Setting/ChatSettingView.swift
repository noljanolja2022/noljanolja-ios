//
//  ChatSettingView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 07/04/2023.
//
//

import _SwiftUINavigationState
import SDWebImageSwiftUI
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

    @ViewBuilder
    private func buildContentView() -> some View {
        if let model = viewModel.contentModel {
            ScrollView {
                VStack(spacing: 2) {
                    buildHeaderView(model.headerType)
                    buildSettingView(model.itemModel)
                    buildLeaveView(model.isLeaveEnabled)
                }
            }
            .background(
                ColorAssets.neutralLightGrey.swiftUIColor
                    .edgesIgnoringSafeArea(.bottom)
            )
        }
    }

    @ViewBuilder
    private func buildHeaderView(_ model: ChatSettingHeaderType) -> some View {
        switch model {
        case let .single(model):
            buildHeaderViewForSingleChat(model)
        case let .group(model):
            buildHeaderViewForGroupChat(model)
        }
    }

    @ViewBuilder
    private func buildHeaderViewForSingleChat(_ model: SingleChatSettingHeaderModel) -> some View {
        if let model = model.participantModel {
            VStack(spacing: 16) {
                WebImage(
                    url: URL(string: model.avatar),
                    context: [
                        .imageTransformer: SDImageResizingTransformer(
                            size: CGSize(width: 64 * 3, height: 64 * 3),
                            scaleMode: .aspectFill
                        )
                    ]
                )
                .resizable()
                .indicator(.activity)
                .scaledToFill()
                .frame(width: 64, height: 64)
                .background(ColorAssets.neutralLightGrey.swiftUIColor)
                .cornerRadius(14)

                Text(model.displayName ?? "")
                    .font(.system(size: 16, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.vertical, 24)
            .padding(.horizontal, 16)
            .background(ColorAssets.neutralLight.swiftUIColor)
        }
    }

    private func buildHeaderViewForGroupChat(_ model: GroupChatSettingHeaderModel) -> some View {
        VStack(spacing: 0) {
            Text("Members")
                .font(.system(size: 16, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 10)
                .padding(.horizontal, 16)

            if model.isAddParticipantsEnabled {
                ChatSettingAddParticipantView()
                    .padding(.vertical, 10)
                    .padding(.horizontal, 16)
                    .onTapGesture {
                        viewModel.navigationType = .contactList
                    }
            }

            ForEach(model.participantModels.indices, id: \.self) { index in
                let participantModel = model.participantModels[index]
                ChatSettingParticipantItemView(
                    model: participantModel
                )
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .background(ColorAssets.neutralLight.swiftUIColor)
                .onTapGesture {
                    guard !participantModel.actionTypes.isEmpty else { return }
                    viewModel.fullScreenCoverType = .participantDetail(participantModel)
                }
            }
        }
        .padding(.bottom, 4)
        .background(ColorAssets.neutralLight.swiftUIColor)
    }

    @ViewBuilder
    private func buildSettingView(_ model: ChatSettingItemModel) -> some View {
        if !model.items.isEmpty {
            VStack(spacing: 0) {
                if !model.isTitleHidden {
                    Divider()
                        .frame(height: 2)
                        .overlay(ColorAssets.neutralLightGrey.swiftUIColor)

                    Text("Settings")
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 16)
                } else {
                    Divider()
                        .frame(height: 5)
                        .overlay(ColorAssets.neutralLightGrey.swiftUIColor)
                }

                ForEach(model.items.indices, id: \.self) { index in
                    buildSettingItemView(with: model.items[index])
                }
            }
            .background(ColorAssets.neutralLight.swiftUIColor)
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
            guard let settingItemType = ChatSettingNavigationType.SettingItemType(itemModel) else { return }
            viewModel.navigationType = .settingItem(settingItemType)
        }
    }

    @ViewBuilder
    private func buildLeaveView(_ model: Bool) -> some View {
        if model {
            Button(
                action: {
                    viewModel.checkLeaveAction.send()
                },
                label: {
                    Text("LEAVE CHAT ROOM")
                        .font(.system(size: 14, weight: .bold))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(12)
                        .foregroundColor(ColorAssets.systemRed100.swiftUIColor)
                        .background(ColorAssets.neutralLight.swiftUIColor)
                        .cornerRadius(4)
                }
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(16)
        }
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
            case .adjustment:
                ConversationAdjustment(
                    viewModel: ConversationAdjustmentModel(
                        conversation: viewModel.conversationSubject.value
                    )
                )
            }
        }
    }
}
