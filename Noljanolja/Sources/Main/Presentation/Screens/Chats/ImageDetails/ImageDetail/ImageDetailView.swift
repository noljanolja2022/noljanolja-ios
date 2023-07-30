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
    @State private var isMoreMenuVisible = false
    
    var body: some View {
        buildBodyView()
    }
    
    private func buildBodyView() -> some View {
        buildContentView()
            .navigationBarTitle("", displayMode: .inline)
            .toolbar { buildToolBarContent() }
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .isProgressHUBVisible($viewModel.isProgressHUDShowing)
            .alert(item: $viewModel.alertState) { Alert($0) { _ in } }
            .fullScreenCover(
                unwrapping: $viewModel.fullScreenCoverType,
                content: {
                    buildFullScreenCoverDestinationView($0)
                }
            )
    }
    
    private func buildContentView() -> some View {
        TabView(selection: $viewModel.selectedIndex) {
            ForEach(viewModel.imageUrls.indices, id: \.self) { index in
                buildItemView(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
    
    private func buildItemView(_ index: Int) -> some View {
        VStack(spacing: 8) {
            Text("\(index + 1)/\(viewModel.imageUrls.count)")
                .dynamicFont(.systemFont(ofSize: 22, weight: .medium))
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            WebImage(url: viewModel.imageUrls[index])
                .resizable()
                .indicator(.activity)
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .background(ColorAssets.neutralLightGrey.swiftUIColor)
                .cornerRadius(20)
                .padding(16)
        }
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
                        viewModel.downloadImageAction.send(
                            viewModel.imageUrls[viewModel.selectedIndex]
                        )
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
                                viewModel.editImageAction.send(
                                    viewModel.imageUrls[viewModel.selectedIndex]
                                )
                            }
                        )
                    ]
                }
            }
            .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
        }
    }
}

extension ImageDetailView {
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
                imageUrls: [
                    URL(string: "https://fujifilm-x.com/wp-content/uploads/2021/01/gfx100s_sample_04_thum-1.jpg")!
                ]
            )
        )
    }
}
