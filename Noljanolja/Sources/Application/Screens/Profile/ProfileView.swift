//
//  ProfileView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/02/2023.
//
//

import SwiftUI

// MARK: - ProfileView

struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel

    @State private var isShowingAuthView = false

    init(viewModel: ProfileViewModel = ProfileViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text(viewModel.token)
                    .font(Font.system(size: 16))
                Button("Auth") {
                    isShowingAuthView = true
                }
                Button(
                    action: {
                        viewModel.signOutTrigger.send()
                    },
                    label: {
                        Text("Sign Out")
                            .font(Font.system(size: 16).bold())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                )
                .frame(height: 48)
                .background(Color.red)
                .cornerRadius(8)
            }
            .padding(16)
        }
        .fullScreenCover(isPresented: $isShowingAuthView) {
            AuthNavigationView()
        }
    }
}

// MARK: - ProfileView_Previews

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
