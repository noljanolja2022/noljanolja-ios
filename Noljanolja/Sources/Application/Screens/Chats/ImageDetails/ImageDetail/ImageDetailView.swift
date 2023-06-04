//
//  ImageDetailView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 26/04/2023.
//
//

import SDWebImageSwiftUI
import SwiftUI
import SwiftUIX

// MARK: - ImageDetailView

struct ImageDetailView<ViewModel: ImageDetailViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    // MARK: State

    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var progressHUBState = ProgressHUBState()
    @State private var isMoreMenuVisible = false

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildContentView()
            .toolbar { buildToolBarContent() }
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .progressHUB(isActive: $progressHUBState.isLoading)
            .environmentObject(progressHUBState)
            .onChange(of: viewModel.isProgressHUDShowing) {
                progressHUBState.isLoading = $0
            }
            .alert(item: $viewModel.alertState) { Alert($0) { _ in } }
            .fullScreenCover(
                unwrapping: $viewModel.fullScreenCoverType,
                content: {
                    buildFullScreenCoverDestinationView($0)
                }
            )
    }

    private func buildContentView() -> some View {
        GeometryReader { _ in
            WebImage(url: viewModel.imageUrl)
                .resizable()
                .indicator(.activity)
                .scaledToFit()
                .cornerRadius(20)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(16)
    }

    @ToolbarContentBuilder
    private func buildToolBarContent() -> some ToolbarContent {
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
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack(spacing: 8) {
                Button(
                    action: {
                        viewModel.downloadImageAction.send()
                    },
                    label: {
                        ImageAssets.icDownload.swiftUIImage
                    }
                )
                Button(
                    action: {
                        isMoreMenuVisible = !isMoreMenuVisible
                    },
                    label: {
                        ImageAssets.icMore.swiftUIImage
                    }
                )
                .editMenu(isVisible: $isMoreMenuVisible) {
                    [
                        EditMenuItem(
                            L10n.commonEdit,
                            action: {
                                viewModel.editImageAction.send()
                            }
                        )
                    ]
                }
            }
            .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
        }
    }

    @ViewBuilder
    private func buildFullScreenCoverDestinationView(
        _ type: Binding<ImageDetailFullScreenCoverType>
    ) -> some View {
        switch type.wrappedValue {
        case let .edit(image):
            ImageEditorView(
                viewModel: ImageEditorViewModel(
                    image: image,
                    delegate: viewModel
                )
            )
        case let .editerResult(image):
            NavigationView {
                ImageEditorResultView(
                    viewModel: ImageEditorResultViewModel(
                        image: image,
                        delegate: viewModel
                    )
                )
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .accentColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            .introspectNavigationController { navigationController in
                navigationController.configure(
                    backgroundColor: ColorAssets.neutralLight.color,
                    foregroundColor: ColorAssets.neutralDarkGrey.color
                )
                navigationController.view.backgroundColor = .clear
                navigationController.parent?.view.backgroundColor = .clear
            }
        }
    }
}

// MARK: - ImageDetailView_Previews

struct ImageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ImageDetailView(
            viewModel: ImageDetailViewModel(
                imageUrl: URL(
                    string: "https://fujifilm-x.com/wp-content/uploads/2021/01/gfx100s_sample_04_thum-1.jpg"
                )!
            )
        )
    }
}
