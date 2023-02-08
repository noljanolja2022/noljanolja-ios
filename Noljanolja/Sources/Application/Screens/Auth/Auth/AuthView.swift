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
        VStack {
            TabLayout(selection: $selectedIndex, tabs: ["Sign In", "Sign Up"])
            TabView(selection: $selectedIndex) {
                SignInView()
                    .tag(0)
                SignUpView()
                    .tag(1)
            }
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
