//
//  CameraView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 20/07/2023.
//
//

import SwiftUI

// MARK: - CameraView

struct CameraView<ViewModel: CameraViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildContentView()
            .onAppear {
                viewModel.isAppearSubject.send(true)
            }
            .onDisappear {
                viewModel.isAppearSubject.send(false)
            }
    }

    private func buildContentView() -> some View {
        ZStack {
            Spacer()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            GeometryReader { geometry in
                if let cgImage = viewModel.previewImage {
                    Image(decorative: cgImage, scale: 1)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                }
            }
            .clipped()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
    }
}

// MARK: - CameraView_Previews

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView(viewModel: CameraViewModel())
    }
}
