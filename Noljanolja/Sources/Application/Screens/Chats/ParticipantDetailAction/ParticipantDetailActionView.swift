//
//  ChatSettingParticipantItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/04/2023.
//
//

import SDWebImageSwiftUI
import SwiftUI

// MARK: - ParticipantDetailActionView

struct ParticipantDetailActionView<ViewModel: ParticipantDetailActionViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    // MARK: State

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        ZStack(alignment: .bottom) {
            Spacer()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    ColorAssets.neutralDarkGrey.swiftUIColor
                        .opacity(0.4)
                        .edgesIgnoringSafeArea(.top)
                )
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            buildContentView()
        }
        .edgesIgnoringSafeArea(.bottom)
        .onAppear { viewModel.isAppearSubject.send(true) }
        .onDisappear { viewModel.isAppearSubject.send(false) }
    }

    private func buildContentView() -> some View {
        VStack(spacing: 0) {
            VStack(spacing: 8) {
                WebImage(
                    url: URL(string: viewModel.participantModel.user.avatar),
                    context: [
                        .imageTransformer: SDImageResizingTransformer(
                            size: CGSize(width: 40 * 3, height: 40 * 3),
                            scaleMode: .aspectFill
                        )
                    ]
                )
                .resizable()
                .indicator(.activity)
                .scaledToFill()
                .frame(width: 40, height: 40)
                .background(ColorAssets.neutralLightGrey.swiftUIColor)
                .cornerRadius(14)
                Text(viewModel.participantModel.user.name ?? "")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            }
            .padding(16)

            ForEach(viewModel.participantModel.actionTypes, id: \.self) { action in
                Button(
                    action: {
                        presentationMode.wrappedValue.dismiss()
                        viewModel.action.send(action)
                    },
                    label: {
                        Text(action.title)
                            .font(.system(size: 16))
                            .foregroundColor(Color(asset: action.color))
                            .padding(12)
                    }
                )
            }

            Spacer()
                .frame(
                    height: UIApplication.shared.rootKeyWindow?.safeAreaInsets.bottom ?? 0
                )
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .background(
            ColorAssets.white.swiftUIColor
                .edgesIgnoringSafeArea(.bottom)
        )
        .cornerRadius([.topLeading, .topTrailing], 24)
    }
}

// MARK: - ParticipantDetailActionView_Previews

struct ParticipantDetailActionView_Previews: PreviewProvider {
    static var previews: some View {
        ParticipantDetailActionView(
            viewModel: ParticipantDetailActionViewModel(
                participantModel: ChatSettingParticipantModel(
                    user: User(
                        id: "",
                        name: "",
                        avatar: nil,
                        pushToken: nil,
                        phone: nil,
                        email: nil,
                        isEmailVerified: false,
                        dob: nil,
                        gender: nil,
                        preferences: nil,
                        createdAt: Date(),
                        updatedAt: Date()
                    )
                )
            )
        )
    }
}
