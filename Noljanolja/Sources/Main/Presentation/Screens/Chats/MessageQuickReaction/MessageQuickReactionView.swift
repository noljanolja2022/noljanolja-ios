//
//  MessageQuickReactionView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 07/07/2023.
//
//

import SwiftUI

// MARK: MessageQuickReactionView

struct MessageQuickReactionView<ViewModel: MessageQuickReactionViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    // MARK: State

    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var progressHUBState = ProgressHUBState()

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildContentView()
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .progressHUB(isActive: $progressHUBState.isLoading)
            .environmentObject(progressHUBState)
            .alert(item: $viewModel.alertState) { Alert($0) { _ in } }
            .onReceive(viewModel.closeAction) {
                presentationMode.wrappedValue.dismiss()
            }
            .introspectViewController {
                $0.view.backgroundColor = .clear
            }
    }

    private func buildContentView() -> some View {
        GeometryReader { geometry in
            let rectCenterX = (viewModel.input.rect.minX + viewModel.input.rect.maxX) / 2
            let horizontalAlignment: HorizontalAlignment = geometry.size.width / 2 > rectCenterX ? .leading : .trailing

            ZStack(alignment: horizontalAlignment == .leading ? .topLeading : .topTrailing) {
                Spacer()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                buildReactionIconsView()
                    .padding(
                        .top,
                        viewModel.input.rect.origin.y - 36
                    )
                    .padding(
                        .leading,
                        horizontalAlignment == .leading
                            ? viewModel.input.rect.origin.x
                            : nil
                    )
                    .padding(
                        .trailing,
                        horizontalAlignment == .leading
                            ? nil
                            : geometry.size.width - viewModel.input.rect.width - viewModel.input.rect.minX
                    )
                    .onTapGesture {}
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background { Color.black.opacity(0.5) }
        .ignoresSafeArea()
        .onTapGesture {
            presentationMode.dismiss()
        }
    }

    private func buildReactionIconsView() -> some View {
        HStack(spacing: 4) {
            ForEach(viewModel.reactionIcons.indices, id: \.self) { index in
                let model = viewModel.reactionIcons[index]
                Button(
                    action: {
                        viewModel.reactionAction.send(model)
                    },
                    label: {
                        Text(model.code ?? "")
                            .dynamicFont(.systemFont(ofSize: 16))
                    }
                )
            }
        }
        .padding(.horizontal, 8)
        .frame(height: 32)
        .background(ColorAssets.neutralLight.swiftUIColor)
        .cornerRadius(8)
    }

    private func buildActionsView() -> some View {
        HStack(spacing: 4) {
            ForEach(MessageActionType.allCases, id: \.self) { model in
                Button(
                    action: {
                        viewModel.action.send(model)
                    },
                    label: {
                        VStack(spacing: 8) {
                            Image(model.imageName)
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text(model.title)
                                .dynamicFont(.systemFont(ofSize: 14, weight: .medium))
                                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                        }
                        .padding(12)
                    }
                )
            }
        }
        .background(ColorAssets.neutralLight.swiftUIColor)
        .cornerRadius(4)
    }
}
