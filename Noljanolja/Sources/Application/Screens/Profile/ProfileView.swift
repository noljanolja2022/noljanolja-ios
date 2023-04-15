//
//  ProfileView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 05/03/2023.
//
//

import Kingfisher
import SwiftUI

// MARK: - ProfileView

struct ProfileView<ViewModel: ProfileViewModelType>: View {
    // MARK: Dependencies

    @StateObject private var viewModel: ViewModel

    // MARK: State

    init(viewModel: ViewModel = ProfileViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        buildContentView()
            .onAppear { viewModel.send(.loadData) }
    }

    private func buildContentView() -> some View {
        VStack(spacing: 16) {
            HStack {
                Spacer()
                NavigationLink(
                    destination: SettingView(
                        viewModel: SettingViewModel(
                            delegate: viewModel
                        )
                    ),
                    label: {
                        Image(systemName: "gearshape")
                            .resizable()
                            .scaledToFit()
                            .padding(8)
                            .frame(width: 44, height: 44)
                            .foregroundColor(.black)
                    }
                )
                .isDetailLink(false)
            }
            .frame(maxWidth: .infinity)

            KFImage(URL(string: viewModel.state.user?.avatar ?? "")).placeholder {
                ImageAssets.icAvatarPlaceholder.swiftUIImage
                    .resizable()
            }
            .resizable()
            .scaledToFill()
            .frame(width: 112, height: 112)
            .background(Color.white)
            .cornerRadius(56)

            Text(viewModel.state.user?.name ?? "")
                .font(.system(size: 16, weight: .bold))

            NavigationLink(
                destination: UpdateCurrentUserView(
                    viewModel: UpdateCurrentUserViewModel()
                ),
                label: {
                    ProfileItemView(imageName: "pencil.slash", title: "Edit Account")
                }
            )
            .isDetailLink(false)

            Spacer()
        }
        .padding(16)
    }
}

// MARK: - ProfileView_Previews

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
