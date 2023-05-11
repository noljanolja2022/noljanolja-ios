//
//  ChatInputView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//
//

import SwiftUI
import SwiftUIX

// MARK: - ChatInputUIViews

final class ChatInputUIViews {
    fileprivate var textView: UITextView?
}

// MARK: - ChatInputView

struct ChatInputView<ViewModel: ChatInputViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    private let uiViews = ChatInputUIViews()

    // MARK: State

    @StateObject private var keyboard = Keyboard.main
    @State private var text = ""
    @State private var expandType: ChatInputExpandType?

    private let inputItemSize: CGFloat = 36

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildContentView()
            .onChange(of: keyboard.isActive) { isActive in
                guard isActive else { return }
                setExpandType(nil, isAnimated: false)
            }
    }

    private func buildContentView() -> some View {
        VStack(spacing: 0) {
            buildTopView()
            buildBottomView()
        }
    }

    private func buildTopView() -> some View {
        HStack(alignment: .bottom, spacing: 4) {
            buildExpandView()
            buildMainView()
        }
        .padding(.leading, 8)
        .padding(.trailing, 12)
        .padding(.vertical, 8)
    }

    private func buildExpandView() -> some View {
        Button(
            action: {
                keyboard.dismiss()
                switch expandType {
                case .none:
                    setExpandType(.menu)
                case .menu, .sticker:
                    setExpandType(nil) {
                        uiViews.textView?.becomeFirstResponder()
                    }
                case .images:
                    setExpandType(.menu)
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
        .rotationEffect(
            .radians(expandType == nil ? 0 : Double.pi / 4)
        )
    }

    private func buildMainView() -> some View {
        ZStack {
            // Phải tách view, Không dùng được cornerRadius trực tiếp cho view
            // Vì không thể dùng func introspectTextView được
            Spacer()
                .alignmentGuide(.top, computeValue: { $0[.top] })
                .alignmentGuide(.bottom, computeValue: { $0[.bottom] })
                .background(ColorAssets.neutralLightGrey.swiftUIColor)
                .cornerRadius(18)
            
            HStack(alignment: .bottom, spacing: 0) {
                buildTextInputView()
                buildKeyboardAndStickerView()
                buildSendView()
            }
        }
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
                .introspectTextView {
                    uiViews.textView = $0
                }
        }
        .font(.system(size: 14))
        .padding(.horizontal, 8)
    }

    @ViewBuilder
    private func buildKeyboardAndStickerView() -> some View {
        Button(
            action: {
                keyboard.dismiss()
                setExpandType(expandType == .sticker ? nil : .sticker)
            },
            label: {
                ImageAssets.icChatEmoji.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .padding(8)
                    .frame(width: inputItemSize, height: inputItemSize)
                    .foregroundColor(ColorAssets.primaryGreen400.swiftUIColor)
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
                : ColorAssets.primaryGreen200.swiftUIColor
        )
    }

    private func buildBottomView() -> some View {
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
        .height(UIScreen.main.bounds.width * 0.6)
    }
}

extension ChatInputView {
    private func setExpandType(_ expandType: ChatInputExpandType?,
                               isAnimated: Bool = true,
                               completion: (() -> Void)? = nil) {
        if isAnimated {
            let milliseconds = keyboard.isActive ? 300 : 0
            withAnimation(
                after: .milliseconds(milliseconds),
                body: {
                    self.expandType = expandType
                }
            )
            DispatchQueue.main.asyncAfter(
                deadline: .now() + TimeInterval(milliseconds / 1_000) + 0.1
            ) {
                completion?()
            }
        } else {
            self.expandType = expandType
            completion?()
        }
    }
}

// MARK: - ChatInputView_Previews

import Combine

// MARK: - ChatInputView_Previews

struct ChatInputView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.green)

            ChatInputView(
                viewModel: ChatInputViewModel(
                    conversationID: 0,
                    sendAction: PassthroughSubject<SendMessageType, Never>()
                )
            )
        }
    }
}
