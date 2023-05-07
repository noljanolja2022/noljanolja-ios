//
//  ImageEditorResultView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 28/04/2023.
//
//

import SDWebImageSwiftUI
import SwiftUI

// MARK: - ImageEditorResultView

struct ImageEditorResultView<ViewModel: ImageEditorResultViewModel>: View {
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
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(
                        action: {
                            presentationMode.wrappedValue.dismiss()
                        },
                        label: {
                            Image(systemName: "xmark")
                        }
                    )
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
            }
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .progressHUB(isActive: $progressHUBState.isLoading)
            .environmentObject(progressHUBState)
            .alert(item: $viewModel.alertState) { Alert($0) { _ in } }
    }

    private func buildContentView() -> some View {
        VStack(spacing: 16) {
            Spacer()
            buildMainView()
            Spacer()
            buildActionsView()
        }
        .padding(16)
    }

    private func buildMainView() -> some View {
        GeometryReader { _ in
            Image(uiImage: viewModel.image)
                .resizable()
                .scaledToFit()
                .cornerRadius(20)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func buildActionsView() -> some View {
        HStack(spacing: 12) {
            Button(
                action: {
                    viewModel.saveAction.send()
                },
                label: {
                    Text("Save")
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .foregroundColor(ColorAssets.neutralLight.swiftUIColor)
                        .background(ColorAssets.neutralDeepGrey.swiftUIColor)
                        .cornerRadius(8)
                }
            )

            Button(
                action: {
                    viewModel.sendAction.send()
                },
                label: {
                    Text("Send")
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .foregroundColor(ColorAssets.neutralLight.swiftUIColor)
                        .background(ColorAssets.primaryGreen200.swiftUIColor)
                        .cornerRadius(8)
                }
            )
        }
        .frame(height: 52)
    }
}

// MARK: - ImageEditorResultView_Previews

struct ImageEditorResultView_Previews: PreviewProvider {
    static var previews: some View {
        ImageEditorResultView(
            viewModel: ImageEditorResultViewModel(
                image: UIImage()
            )
        )
    }
}
