//
//  ChatInputImagePreviewView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 12/05/2023.
//
//

import SDWebImageSwiftUI
import SwiftUI

// MARK: - ChatInputImagePreviewView

struct ChatInputImagePreviewView<ViewModel: ChatInputImagePreviewViewModel>: View {
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
            .alert(item: $viewModel.alertState) { Alert($0) { _ in } }
    }

    private func buildContentView() -> some View {
        VStack(spacing: 12) {
            buildMainView()
            buildActionsView()
        }
        .padding(16)
        .background(.black)
    }

    private func buildMainView() -> some View {
        ZStack(alignment: .topLeading) {
            GeometryReader { _ in
                Image(uiImage: viewModel.image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(20)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            Button(
                action: {
                    presentationMode.wrappedValue.dismiss()
                },
                label: {
                    ImageAssets.icClose.swiftUIImage
                        .resizable()
                        .padding(6)
                        .frame(width: 24, height: 24)
                        .foregroundColor(ColorAssets.neutralLight.swiftUIColor)
                        .background(.black)
                        .cornerRadius(12)
                }
            )
        }
    }

    private func buildActionsView() -> some View {
        HStack(spacing: 0) {
            Button(
                action: {
                    viewModel.downloadImageAction.send()
                },
                label: {
                    HStack(spacing: 8) {
                        ImageAssets.icDownload.swiftUIImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)

                        Text("Save")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .foregroundColor(ColorAssets.primaryGreen200.swiftUIColor)
                }
            )

            Spacer()

            Button(
                action: {
                    viewModel.sendImageAction.send()
                    presentationMode.wrappedValue.dismiss()
                },
                label: {
                    HStack(spacing: 8) {
                        Text("Send")
                            .font(.system(size: 16, weight: .bold))

                        ImageAssets.icSend.swiftUIImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                    .foregroundColor(ColorAssets.primaryGreen200.swiftUIColor)
                }
            )
        }
    }
}

// MARK: - ChatInputImagePreviewView_Previews

struct ChatInputImagePreviewView_Previews: PreviewProvider {
    static var previews: some View {
        ChatInputImagePreviewView(
            viewModel: ChatInputImagePreviewViewModel(
                image: UIImage()
            )
        )
    }
}
