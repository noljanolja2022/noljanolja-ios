//
//  MessageActionDetailView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/06/2023.
//
//

import SwiftUI
import SwiftUIX

// MARK: - MessageActionDetailView

struct MessageActionDetailView<ViewModel: MessageActionDetailViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    // MARK: State

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildContentView()
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .isProgressHUBVisible($viewModel.isProgressHUDShowing)
            .alert(item: $viewModel.alertState) { Alert($0) { _ in } }
            .onReceive(viewModel.closeAction) {
                withoutAnimation {
                    presentationMode.wrappedValue.dismiss()
                }
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

                VStack(alignment: horizontalAlignment, spacing: 4) {
                    buildReactionIconsView()
                    MessageContentView(
                        model: viewModel.input.normalMessageModel.content
                    )
                    .frame(
                        width: viewModel.input.rect.width,
                        height: viewModel.input.rect.height
                    )
                    buildActionsView()
                }
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
            withoutAnimation {
                presentationMode.dismiss()
            }
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
            ForEach(viewModel.messageActionTypes, id: \.self) { model in
                Button(
                    action: {
                        viewModel.action.send(model)
                    },
                    label: {
                        VStack(spacing: 8) {
                            Image(model.imageName)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(ColorAssets.primaryGreen200.swiftUIColor)
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
