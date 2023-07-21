//
//  ConversationAdjustment.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/04/2023.
//
//

import SDWebImageSwiftUI
import SwiftUI
import SwiftUINavigation
import SwiftUIX

// MARK: - ConversationAdjustment

struct ConversationAdjustment<ViewModel: ConversationAdjustmentModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    // MARK: State

    @Environment(\.presentationMode) private var presentationMode

    @EnvironmentObject private var progressHUBState: ProgressHUBState

    @StateObject private var keyboard = Keyboard.main

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
            .alert(item: $viewModel.alertState) {
                Alert($0) { _ in }
            }
            .onReceive(viewModel.closeSubject) {
                presentationMode.wrappedValue.dismiss()
            }
            .actionSheet(item: $viewModel.actionSheetType) {
                buildActionSheetDestinationView($0)
            }
            .fullScreenCover(
                unwrapping: $viewModel.fullScreenCoverType,
                content: {
                    buildFullScreenCoverDestinationView($0)
                }
            )
    }

    private func buildContentView() -> some View {
        VStack(spacing: 32) {
            buildAvatarView()
            buildTitleView()

            Spacer()

            Button(
                L10n.commonSave.uppercased(),
                action: { viewModel.actionSubject.send() }
            )
            .buttonStyle(PrimaryButtonStyle())
            .font(.system(size: 16, weight: .bold))
        }
        .padding(16)
    }

    private func buildAvatarView() -> some View {
        ZStack(alignment: .bottomTrailing) {
            IfLet(
                $viewModel.image,
                then: {
                    Image(uiImage: $0.wrappedValue)
                        .resizable()
                },
                else: {
                    WebImage(
                        url: URL(string: ""),
                        context: [
                            .imageTransformer: SDImageResizingTransformer(
                                size: CGSize(width: 86 * 3, height: 86 * 3),
                                scaleMode: .aspectFill
                            )
                        ]
                    )
                    .placeholder {
                        ImageAssets.icChatPlaceholderGroup.swiftUIImage
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                            .padding(24)
                    }
                    .resizable()
                }
            )
            .scaledToFill()
            .frame(width: 86, height: 86)
            .background(ColorAssets.primaryGreen100.swiftUIColor)
            .cornerRadius(28)

            Button(
                action: {
                    viewModel.actionSheetType = .avatar
                },
                label: {
                    ImageAssets.icCameraFill.swiftUIImage
                        .resizable()
                        .scaledToFit()
                        .padding(6)
                        .frame(width: 32, height: 32)
                        .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
                        .background(ColorAssets.neutralLightGrey.swiftUIColor)
                        .cornerRadius(22)
                }
            )
            .padding(.trailing, -8)
            .padding(.bottom, -8)
        }
    }

    private func buildTitleView() -> some View {
        VStack(spacing: 8) {
            Text(L10n.editChatChangeRoomAdjustmentDescription)
                .font(.system(size: 16))
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)

            CocoaTextField("Title", text: $viewModel.title)
                .font(.system(size: 16, weight: .bold))
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 8)
                .frame(height: 48)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                .background(ColorAssets.neutralLightGrey.swiftUIColor)
                .cornerRadius(6)
        }
    }

    private func buildActionSheetDestinationView(
        _ type: ConversationAdjustmentActionSheetType
    ) -> ActionSheet {
        switch type {
        case .avatar:
            return ActionSheet(
                title: Text(L10n.updateProfileAvatar),
                buttons: [
                    .default(Text(L10n.updateProfileAvatarOpenCamera)) {
                        keyboard.dismiss()
                        viewModel.fullScreenCoverType = .imagePickerView(.camera)
                    },
                    .default(Text(L10n.updateProfileAvatarSelectPhoto)) {
                        keyboard.dismiss()
                        viewModel.fullScreenCoverType = .imagePickerView(.photoLibrary)
                    },
                    .cancel(Text(L10n.commonCancel))
                ]
            )
        }
    }

    @ViewBuilder
    private func buildFullScreenCoverDestinationView(
        _ type: Binding<ConversationAdjustmentFullScreenCoverType>
    ) -> some View {
        switch type.wrappedValue {
        case let .imagePickerView(sourceType):
            ImagePicker(image: $viewModel.image)
                .sourceType(sourceType)
                .allowsEditing(true)
                .introspectViewController {
                    switch sourceType {
                    case .photoLibrary, .savedPhotosAlbum:
                        break
                    case .camera:
                        $0.view.backgroundColor = .black
                    @unknown default:
                        break
                    }
                }
        }
    }
}

// MARK: - ConversationAdjustment_Previews

struct ConversationAdjustment_Previews: PreviewProvider {
    static var previews: some View {
        ConversationAdjustment(
            viewModel: ConversationAdjustmentModel(
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
