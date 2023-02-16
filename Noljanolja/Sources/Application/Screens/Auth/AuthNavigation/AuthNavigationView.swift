//
//  AuthNavigationView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 11/02/2023.
//
//

import SwiftUI

// MARK: - AuthNavigationView

struct AuthNavigationView<ViewModel: AuthNavigationViewModelType>: View {
    // MARK: Dependencies

    @StateObject private var viewModel: ViewModel

    // MARK: State

    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var progressHUBState = ProgressHUBState()

    init(viewModel: ViewModel = AuthNavigationViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            content
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(
                            action: {
                                presentationMode.wrappedValue.dismiss()
                            },
                            label: {
                                ImageAssets.icClose.swiftUIImage
                                    .resizable()
                                    .foregroundColor(ColorAssets.forcegroundPrimary.swiftUIColor)
                            }
                        )
                    }
                }
        }
        .progressHUB(isActive: $progressHUBState.isLoading)
        .environmentObject(progressHUBState)
    }

    private var content: some View {
        VStack(spacing: 0) {
            ImageAssets.logo.swiftUIImage
                .frame(width: 166, height: 66)
                .padding(16)

            NavigationView {
                AuthView()
            }
            .padding(.top, 8)
            .accentColor(ColorAssets.black.swiftUIColor)
            .background(Color.white)
            .cornerRadius(24, corners: [.topLeft, .topRight])
        }
        .background(
            ColorAssets.highlightPrimary.swiftUIColor.edgesIgnoringSafeArea(.top)
        )
    }
}

// MARK: - AuthNavigationView_Previews

struct AuthNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthNavigationView()
    }
}
