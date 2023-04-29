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

struct ChatInputView<ViewModel: ChatInputViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    // MARK: State

    @StateObject private var keyboard = Keyboard.main
    @State private var text = ""
    @State private var expandType: ChatInputExpandType?

    private let inputItemSize: CGFloat = 36

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        VStack(spacing: 0) {
            buildContentView()
            buildExpandView()
        }
        .onChange(of: keyboard.isActive) { isActive in
            guard isActive else { return }
            expandType = nil
        }
    }

    private func buildContentView() -> some View {
        HStack(alignment: .bottom, spacing: 4) {
            Button(
                action: {
                    withAnimation {
                        keyboard.dismiss()
                        DispatchQueue.main.asyncAfter(
                            deadline: .now() + (keyboard.isActive ? 0.3 : 0)
                        ) {
                            withAnimation {
                                expandType = .menu
                            }
                        }
                    }
                },
                label: {
                    ImageAssets.icAdd.swiftUIImage
                        .resizable()
                        .scaledToFit()
                        .padding(4)
                        .frame(width: inputItemSize, height: inputItemSize)
                        .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
                }
            )

            buildMainView()
        }
        .padding(.leading, 8)
        .padding(.trailing, 12)
        .padding(.vertical, 4)
    }

    private func buildMainView() -> some View {
        HStack(alignment: .bottom, spacing: 0) {
            buildTextInputView()
            buildKeyboardAndStickerView()
            buildSendView()
        }
        .background(ColorAssets.neutralLightGrey.swiftUIColor)
        .cornerRadius(18)
    }

    private func buildTextInputView() -> some View {
        ZStack(alignment: .center) {
            if text.isEmpty {
                Text("Aa")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(ColorAssets.neutralGrey.swiftUIColor)
                    .padding(.horizontal, 6)
            }
            TextEditor(text: $text)
                .textEditorBackgroundColor(.clear)
                .padding(.vertical, 1)
                .frame(minHeight: inputItemSize)
                .frame(maxHeight: 64)
                .fixedSize(horizontal: false, vertical: true)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
        }
        .font(.system(size: 14))
        .padding(.horizontal, 8)
    }

    @ViewBuilder
    private func buildKeyboardAndStickerView() -> some View {
        Button(
            action: {
                keyboard.dismiss()
                DispatchQueue.main.asyncAfter(
                    deadline: .now() + (keyboard.isActive ? 0.3 : 0)
                ) {
                    withAnimation {
                        expandType = expandType == .sticker ? nil : .sticker
                    }
                }
            },
            label: {
                ImageAssets.icEmoji.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .padding(8)
                    .frame(width: inputItemSize, height: inputItemSize)
                    .foregroundColor(ColorAssets.primaryDark.swiftUIColor)
            }
        )
    }

    private func buildSendView() -> some View {
        Button(
            action: {
                viewModel.sendAction.send(.text(text))
                text = ""
            },
            label: {
                ImageAssets.icSend.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: inputItemSize, height: inputItemSize)
            }
        )
        .foregroundColor(
            text.isEmpty
                ? ColorAssets.neutralDeepGrey.swiftUIColor
                : ColorAssets.primaryMain.swiftUIColor
        )
    }

    private func buildExpandView() -> some View {
        ChatInputExpandView(
            viewModel: ChatInputExpandViewModel(
                delegate: viewModel
            ),
            expandType: $expandType,
            sendPhotoAction: {
                viewModel.sendAction.send(.photoAssets($0))
            },
            sendStickerAction: {
                viewModel.sendAction.send(.sticker($0, $1))
            }
        )
        .height(300)
    }
}

// MARK: - ChatInputView_Previews

import Combine

// MARK: - ChatInputView_Previews

struct ChatInputView_Previews: PreviewProvider {
    static var previews: some View {
        ChatInputView(
            viewModel: ChatInputViewModel(
                conversationID: 0,
                sendAction: PassthroughSubject<SendMessageType, Never>()
            )
        )
    }
}
