//
//  ScanQRView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 11/06/2023.
//
//

import SwiftUI
import SwiftUIX

// MARK: - ScanQRView

struct ScanQRView<ViewModel: ScanQRViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        ZStack {
            buildContentView()
            buildNavigationLink()
        }
        .navigationBarTitle("", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(L10n.scanQrCodeTitle)
                    .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            }
        }
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
        VStack(spacing: 12) {
            CameraStatefulView(
                viewModel: CameraStatefulViewModel(
                    cameraViewModel: viewModel.cameraViewModel
                )
            )
            Spacer()
            buildActionsView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func buildActionsView() -> some View {
        Button(
            L10n.chatActionAlbum.uppercased(),
            action: {
                viewModel.fullScreenCoverType = .imagePicker
            }
        )
        .buttonStyle(PrimaryButtonStyle())
        .dynamicFont(.systemFont(ofSize: 16, weight: .medium))
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }

    @ViewBuilder
    private func buildNavigationLink() -> some View {
        NavigationLink(
            unwrapping: $viewModel.navigationType,
            onNavigate: { _ in },
            destination: { buildNavigationDestinationView($0) },
            label: {}
        )
    }
}

extension ScanQRView {
    @ViewBuilder
    private func buildNavigationDestinationView(
        _ type: Binding<ScanQRNavigationType>
    ) -> some View {
        switch type.wrappedValue {
        case let .result(users):
            FindUsersResultView(
                viewModel: FindUsersResultViewModel(users: users)
            )
        }
    }

    @ViewBuilder
    private func buildFullScreenCoverDestinationView(
        _ type: Binding<ScanQRFullScreenCoverType>
    ) -> some View {
        switch type.wrappedValue {
        case .imagePicker:
            ImagePicker(image: $viewModel.image)
        }
    }
}

// MARK: - ScanQRView_Previews

struct ScanQRView_Previews: PreviewProvider {
    static var previews: some View {
        ScanQRView(viewModel: ScanQRViewModel())
    }
}
