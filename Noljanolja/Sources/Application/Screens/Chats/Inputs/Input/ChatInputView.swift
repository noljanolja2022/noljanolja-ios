//
//  ChatInputView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//
//

import SDWebImageSwiftUI
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
    @State private var photoAssets = [PhotoAsset]()

    // MARK: Private

    private let inputItemSize: CGFloat = 36

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildContentView()
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .onChange(of: keyboard.isActive) { isActive in
                guard isActive else { return }
                setExpandType(nil, isAnimated: false)
            }
            .onReceive(viewModel.isTextFirstResponderAction) {
                if $0 {
                    uiViews.textView?.becomeFirstResponder()
                } else {
                    keyboard.dismiss()
                }
            }
    }

    private func buildContentView() -> some View {
        VStack(spacing: 0) {
            buildOverlayView()
            buildTopView()
            buildBottomView()
        }
    }

    private func buildOverlayView() -> some View {
        Spacer()
            .frame(maxWidth: .infinity)
            .frame(height: 0)
            .overlay(alignment: .bottom) {
                buildPreviewView()
            }
    }

    @ViewBuilder
    private func buildPreviewView() -> some View {
        if let (stickerPack, sticker) = viewModel.previewSticker {
            ZStack(alignment: .topTrailing) {
                AnimatedImage(
                    url: sticker.getImageURL(stickerPack.id),
                    isAnimating: .constant(true)
                )
                .resizable()
                .indicator(.activity)
                .scaledToFit()
                .frame(width: 100, height: 100)
                .frame(maxWidth: .infinity)

                Button(
                    action: {
                        viewModel.previewSticker = nil
                    },
                    label: {
                        ImageAssets.icClose.swiftUIImage
                            .resizable()
                            .padding(4)
                            .frame(width: 24, height: 24)
                            .foregroundColor(ColorAssets.neutralLight.swiftUIColor)
                    }
                )
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(ColorAssets.neutralDarkGrey.swiftUIColor.opacity(0.5))
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
        .background(
            expandType != nil
                ? ColorAssets.neutralLightGrey.swiftUIColor
                : ColorAssets.neutralLight.swiftUIColor
        )
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            viewModel.isTextFirstResponderAction.send(true)
                        }
                    }
                case .images:
                    setExpandType(.menu)
                    photoAssets.removeAll()
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
            .radians(expandType != nil ? Double.pi / 4 : 0)
        )
    }

    private func buildMainView() -> some View {
        ZStack {
            // Phải tách view, Không dùng được cornerRadius trực tiếp cho view
            // Vì không thể dùng func introspectTextView được
            Spacer()
                .alignmentGuide(.leading, computeValue: { $0[.leading] })
                .alignmentGuide(.top, computeValue: { $0[.top] })
                .alignmentGuide(.trailing, computeValue: { $0[.trailing] })
                .alignmentGuide(.bottom, computeValue: { $0[.bottom] })
                .background(ColorAssets.neutralLightGrey.swiftUIColor)
                .cornerRadius(18)
                .hidden(expandType != nil)

            HStack(alignment: .bottom, spacing: 0) {
                HStack(alignment: .bottom, spacing: 0) {
                    buildTextInputView()
                    buildStickerView()
                }
                .hidden(expandType != nil)

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
                    viewModel.didReceiveTextViewAction.send()
                }
        }
        .font(.system(size: 14))
        .padding(.horizontal, 8)
    }

    @ViewBuilder
    private func buildStickerView() -> some View {
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
        let isHidden = {
            switch expandType {
            case .none: return text.isEmpty
            case .menu: return true
            case .images: return photoAssets.isEmpty
            case .sticker: return viewModel.previewSticker == nil
            }
        }()
        let isDisabled = text.isEmpty && photoAssets.isEmpty && viewModel.previewSticker == nil
        return Button(
            action: {
                switch expandType {
                case .none:
                    guard !text.isEmpty else { return }
                    viewModel.sendAction.send(.text(text))
                    text = ""
                case .menu:
                    break
                case .images:
                    guard !photoAssets.isEmpty else { return }
                    viewModel.sendAction.send(.photoAssets(photoAssets))
                    photoAssets.removeAll()
                case .sticker:
                    guard let (stickerPack, sticker) = viewModel.previewSticker else { return }
                    viewModel.sendAction.send(.sticker(stickerPack, sticker))
                    viewModel.previewSticker = nil
                }
            },
            label: {
                ImageAssets.icSend.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: inputItemSize, height: inputItemSize)
            }
        )
        .foregroundColor(
            isDisabled
                ? ColorAssets.neutralDeepGrey.swiftUIColor
                : ColorAssets.primaryGreen200.swiftUIColor
        )
        .visible(isHidden ? .gone : .visible)
        .disabled(isDisabled)
    }

    private func buildBottomView() -> some View {
        ChatInputExpandView(
            viewModel: ChatInputExpandViewModel(
                delegate: viewModel
            ),
            expandType: $expandType,
            photoAssets: $photoAssets
        )
        .height(UIScreen.main.bounds.width * 0.6)
    }
}

extension ChatInputView {
    private func setExpandType(_ expandType: ChatInputExpandType?,
                               isAnimated: Bool = true,
                               completion: (() -> Void)? = nil) {
        if isAnimated {
            let milliseconds = keyboard.isActive ? 0.3 : 0
            withAnimation(
                after: .microseconds(Int(milliseconds * 1_000)),
                body: {
                    self.expandType = expandType
                }
            )
            DispatchQueue.main.asyncAfter(
                deadline: .now() + milliseconds
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
