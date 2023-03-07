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
        content
    }

    var content: some View {
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
            }
            .frame(maxWidth: .infinity)

            KFImage(URL(string: viewModel.state.profileModel?.profileImage ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 140, height: 140)
                .background(Color.gray.opacity(0.5))
                .cornerRadius(52)

            Text(viewModel.state.profileModel?.name ?? "")
                .font(FontFamily.NotoSans.medium.swiftUIFont(fixedSize: 16))

            NavigationLink(
                destination: UpdateProfileView(),
                label: {
                    ProfileItemView(imageName: "pencil.slash", title: "Edit Account")
                }
            )

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
