//
//  ChatInputView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//
//

import SwiftUI
import SwiftUIX

// MARK: - ChatInputView

struct ChatInputView<ViewModel: ChatInputViewModelType>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    // MARK: State

    @ObservedObject private var keyboard = Keyboard.main
    @State private var isMediaInputHidden = false
    @State private var mediaType: ChatMediaInputType?

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        VStack(spacing: 0) {
            buildInputsView()

            ChatMediaInputView(
                viewModel: ChatMediaInputViewModel(),
                type: $mediaType,
                photoAssets: $viewModel.photoAssets,
                sendPhotoAction: { viewModel.sendPhotoSubject.send() },
                sendStickerAction: { viewModel.sendStickerSubject.send(($0, $1)) }
            )
            .height(300)
        }
    }

    private func buildInputsView() -> some View {
        HStack(spacing: 10) {
            buildMediaInputsView()
            buildTextInputView()
            buildSendView()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
    }

    private func buildMediaInputsView() -> some View {
        HStack(spacing: 10) {
            if !isMediaInputHidden {
                HStack(spacing: 10) {
                    Button(
                        action: {},
                        label: {
                            ImageAssets.icAddCircle.swiftUIImage
                                .resizable()
                                .scaledToFill()
                                .frame(width: 24, height: 24)
                        }
                    )
                    Button(
                        action: {},
                        label: {
                            ImageAssets.icCamera.swiftUIImage
                                .resizable()
                                .scaledToFill()
                                .frame(width: 24, height: 24)
                        }
                    )
                    Button(
                        action: {
                            keyboard.dismiss()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                withAnimation {
                                    viewModel.photoAssets = []
                                    mediaType = .photo
                                }
                            }
                        },
                        label: {
                            ImageAssets.icPhoto.swiftUIImage
                                .resizable()
                                .scaledToFill()
                                .frame(width: 24, height: 24)
                        }
                    )
                    Button(
                        action: {},
                        label: {
                            ImageAssets.icKeyboardVoice.swiftUIImage
                                .resizable()
                                .scaledToFill()
                                .frame(width: 24, height: 24)
                        }
                    )
                }
            } else {
                Button(
                    action: {
                        withAnimation {
                            isMediaInputHidden = false
                        }
                    },
                    label: {
                        Image(systemName: "chevron.right")
                            .resizable()
                            .scaledToFit()
                            .padding(4)
                            .frame(width: 24, height: 24)
                    }
                )
            }
        }
        .frame(height: 40)
        .foregroundColor(ColorAssets.primaryYellow3.swiftUIColor)
    }

    private func buildTextInputView() -> some View {
        HStack(alignment: .bottom) {
            ZStack(alignment: .center) {
                if viewModel.text.isEmpty {
                    Text("Aa")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(ColorAssets.neutralGrey.swiftUIColor)
                        .padding(.horizontal, 10)
                }
                TextEditor(text: $viewModel.text)
                    .textEditorBackgroundColor(.clear)
                    .frame(minHeight: 32)
                    .frame(maxHeight: 58)
                    .padding(4)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            }
            .font(.system(size: 14))

            Button(
                action: {
                    keyboard.dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation {
                            mediaType = .sticker
                        }
                    }
                },
                label: {
                    ImageAssets.icEmoji.swiftUIImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 24, height: 24)
                        .foregroundColor(ColorAssets.primaryYellow4.swiftUIColor)
                }
            )
            .padding(9)
        }
        .background(ColorAssets.neutralLightGrey.swiftUIColor.opacity(0.6))
        .cornerRadius(8)
        .onChange(of: viewModel.text) { _ in
            withAnimation {
                isMediaInputHidden = true
            }
        }
        .onChange(of: keyboard.isActive) { isActive in
            guard isActive else { return }
            withAnimation {
                isMediaInputHidden = true
                mediaType = nil
            }
        }
    }

    private func buildSendView() -> some View {
        Button(
            action: { viewModel.sendTextSubject.send() },
            label: {
                ImageAssets.icSend.swiftUIImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 32, height: 32)
            }
        )
        .foregroundColor(ColorAssets.primaryYellow3.swiftUIColor)
    }
}

// MARK: - ChatInputView_Previews

struct ChatInputView_Previews: PreviewProvider {
    static var previews: some View {
        ChatInputView(
            viewModel: ChatInputViewModel(
                conversationID: 0
            )
        )
    }
}
