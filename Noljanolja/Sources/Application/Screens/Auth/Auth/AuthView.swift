//
//  AuthView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 07/02/2023.
//

import Introspect
import SwiftUI

// MARK: - AuthView

struct AuthView: View {
    @StateObject private var viewModel: AuthViewModel

    @State private var selectedIndex = 0

    init(viewModel: AuthViewModel = AuthViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            ImageAssets.logo.swiftUIImage
                .frame(width: 166, height: 66)
                .padding(.vertical, 64)
            content
        }
        .background(ColorAssets.highlightPrimary.swiftUIColor.edgesIgnoringSafeArea(.top))
    }

    var content: some View {
        VStack(spacing: 0) {
            TabLayout(
                selection: $selectedIndex,
                tabs: [L10n.Auth.LogIn.title, L10n.Auth.JoinTheMembership.title],
                font: FontFamily.NotoSans.bold.swiftUIFont(size: 16),
                accentColor: ColorAssets.forcegroundTertiary.swiftUIColor,
                selectedAccentColor: ColorAssets.white.swiftUIColor,
                backgroundColor: ColorAssets.gray.swiftUIColor,
                selectedBackgroundColor: ColorAssets.black.swiftUIColor
            )
            .frame(height: 42)
            .padding(.top, 18)

            TabView(selection: $selectedIndex) {
                SignInView().tag(0)
                SignUpView().tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .introspectTabBarController { tabBarController in
                tabBarController.tabBar.isHidden = true
            }
        }
        .background(Color.white)
        .cornerRadius(24, corners: [.topLeft, .topRight])
    }
}

// MARK: - AuthView_Previews

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
