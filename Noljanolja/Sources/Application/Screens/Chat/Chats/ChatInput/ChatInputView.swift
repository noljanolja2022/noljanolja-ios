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
    }

    var body: some View {
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
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                        }
                    )
                    Button(
                        action: {},
                        label: {
                            Image(systemName: "camera.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                        }
                    )
                    Button(
                        action: {},
                        label: {
                            Image(systemName: "photo.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                        }
                    )
                    Button(
                        action: {},
                        label: {
                            Image(systemName: "mic.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                        }
                    )
                }
                .transition(.leadCrossDissolve)
            } else {
                Button(
                    action: { endEditing() },
                    label: {
                        Image(systemName: "chevron.right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                )
                .transition(.opacity)
            }
        }
        .foregroundColor(ColorAssets.primaryYellow3.swiftUIColor)
    }

    private func buildTextInputView() -> some View {
        TextField(
            "Aa",
            text: $viewModel.state.text,
            onEditingChanged: { isEditing in
                withAnimation { isMediaInputHidden = isEditing }
            }
        )
        .padding(.horizontal, 8)
        .padding(.vertical, 12)
        .background(ColorAssets.neutralDarkGrey.swiftUIColor.opacity(0.6))
        .foregroundColor(ColorAssets.neutralLight.swiftUIColor)
        .cornerRadius(8)
    }

    private func buildSendView() -> some View {
        Button(
            action: { viewModel.send(.sendPlaintextMessage) },
            label: {
                Image(systemName: "arrowtriangle.right.circle.fill")
                    .resizable()
                    .scaledToFit()
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
