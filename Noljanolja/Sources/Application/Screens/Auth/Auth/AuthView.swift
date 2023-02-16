//
//  AuthView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 07/02/2023.
//

import Introspect
import SwiftUI

// MARK: - AuthView

struct AuthView<ViewModel: AuthViewModelType>: View {
    // MARK: Dependencies

    @StateObject private var viewModel: ViewModel
    
    // MARK: State

    @State private var selectedIndex = 0

    init(viewModel: ViewModel = AuthViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            content
            NavigationLink(
                destination: ResetPasswordView(),
                isActive: $viewModel.isShowingResetPasswordView,
                label: { EmptyView() }
            )
            NavigationLink(
                destination: TermDetailView(
                    viewModel: TermDetailViewModel(
                        termItemType: viewModel.termItemType ?? .termOfService
                    )
                ),
                isActive: Binding<Bool>(
                    get: {
                        viewModel.termItemType != nil
                    },
                    set: {
                        if !$0 {
                            viewModel.termItemType = nil
                        }
                    }
                ),
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
                SignInView(
                    viewModel: SignInViewModel(delegate: viewModel)
                )
                .tag(0)
                SignUpNavigationView(
                    viewModel: SignUpNavigationViewModel(delegate: viewModel)
                )
                .tag(1)
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
