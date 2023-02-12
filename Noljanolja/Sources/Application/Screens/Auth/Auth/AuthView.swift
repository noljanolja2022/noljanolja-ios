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
    @State private var isShowingResetPasswordView = false
    
    init(viewModel: AuthViewModel = AuthViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            content
            NavigationLink(
                destination: ResetPasswordView(isShowingResetPasswordView: $isShowingResetPasswordView),
                isActive: $isShowingResetPasswordView,
                label: { EmptyView() }
            )
        }
        .navigationBarHidden(true)
    }

    private var content: some View {
        VStack(spacing: 8) {
            TabLayout(
                selection: $selectedIndex,
                tabs: [L10n.Auth.SignIn.title, L10n.Auth.JoinTheMembership.title],
                font: FontFamily.NotoSans.bold.swiftUIFont(size: 16),
                accentColor: ColorAssets.forcegroundTertiary.swiftUIColor,
                selectedAccentColor: ColorAssets.white.swiftUIColor,
                backgroundColor: ColorAssets.gray.swiftUIColor,
                selectedBackgroundColor: ColorAssets.black.swiftUIColor
            )
            .frame(height: 42)
            .padding(.top, 12)

            TabView(selection: $selectedIndex) {
                SignInView(isShowingResetPasswordView: $isShowingResetPasswordView).tag(0)
                SignUpRootView().tag(1)
            }
            //                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .introspectTabBarController { tabBarController in
                tabBarController.tabBar.isHidden = true
            }
        }
    }
}

// MARK: - AuthView_Previews

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
