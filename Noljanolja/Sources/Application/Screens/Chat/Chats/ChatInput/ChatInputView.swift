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

    @StateObject private var viewModel: ViewModel

    // MARK: State

    @State private var isMediaInputHidden = false

    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)

        UITextView.appearance().backgroundColor = .clear
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
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
                        action: {},
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
        ZStack(alignment: .center) {
            if viewModel.state.text.isEmpty {
                Text("Aa")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(ColorAssets.neutralGrey.swiftUIColor)
                    .padding(.horizontal, 10)
            }
            TextEditor(text: $viewModel.state.text)
                .textEditorBackgroundColor(.clear)
                .frame(minHeight: 32)
                .frame(maxHeight: 58)
                .padding(4)
                .fixedSize(horizontal: false, vertical: true)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
        }
        .font(.system(size: 14))
        .background(ColorAssets.neutralLightGrey.swiftUIColor.opacity(0.6))
        .cornerRadius(8)
        .onChange(of: viewModel.state.text) { _ in
            withAnimation {
                isMediaInputHidden = true
            }
        }
    }

    private func buildSendView() -> some View {
        Button(
            action: { viewModel.send(.sendPlaintextMessage) },
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
                state: ChatInputViewModel.State(
                    conversationID: 0
                )
            )
        )
    }
}
