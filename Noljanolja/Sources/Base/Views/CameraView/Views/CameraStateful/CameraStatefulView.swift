//
//  CameraStatefulView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 20/07/2023.
//
//

import SwiftUI

// MARK: - CameraStatefulView

struct CameraStatefulView<ViewModel: CameraStatefulViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        ZStack {
            switch viewModel.viewState {
            case .content: buildContentView()
            case .error: buildErrorView()
            case .loading, .none: buildEmptyView()
            }
        }
        .onAppear { viewModel.isAppearSubject.send(true) }
        .onDisappear { viewModel.isAppearSubject.send(false) }
    }

    private func buildContentView() -> some View {
        CameraView(viewModel: viewModel.cameraViewModel)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black)
    }

    private func buildErrorView() -> some View {
        VStack(spacing: 16) {
            Text(L10n.permissionRequiredDescription)
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
                .foregroundColor(ColorAssets.neutralRawLight.swiftUIColor)

            Button(L10n.permissionGoToSettings) {
                guard let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) else { return }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            .font(.system(size: 16, weight: .bold))
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
            .foregroundColor(ColorAssets.neutralRawLight.swiftUIColor)
            .background(ColorAssets.primaryGreen200.swiftUIColor)
            .cornerRadius(8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
    }

    private func buildEmptyView() -> some View {
        Spacer()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black)
    }
}

// MARK: - CameraStatefulView_Previews

struct CameraStatefulView_Previews: PreviewProvider {
    static var previews: some View {
        CameraStatefulView(
            viewModel: CameraStatefulViewModel(
                cameraViewModel: CameraViewModel()
            )
        )
    }
}
