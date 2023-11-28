//
//  InviteFriendsView.swift
//  Noljanolja
//
//  Created by duydinhv on 28/11/2023.
//

import SwiftUI

// MARK: - InviteFriendsView

struct InviteFriendsView<ViewModel: InviteFriendsViewModel>: View {
    @StateObject var viewModel: ViewModel

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        contentView()
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(L10n.joinPlay)
                        .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
            }
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .edgesIgnoringSafeArea(.bottom)
    }

    private func contentView() -> some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                bannerView()
                VStack(spacing: 13) {
                    actionView()
                    stepInviteView()
                    footerView()
                    Spacer()
                }
                .background(ColorAssets.secondaryYellow50.swiftUIColor)
            }
        }
    }

    private func bannerView() -> some View {
        ImageAssets.bannerHeaderInvite.swiftUIImage
            .resizable()
            .height(262)
            .scaledToFit()
    }

    private func actionView() -> some View {
        Group {
            GeometryReader { proxy in
                let width = proxy.size.width
                let height = proxy.size.height
                HStack(spacing: 0) {
                    Text("DHTKFKDWKD") //MARK: Referal string
                        .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                        .frame(width: width * 0.7, height: height)
                        .background(
                            Rectangle()
                                .fill(ColorAssets.neutralLight.swiftUIColor)
                        )
                    Text(L10n.commonCopy.uppercased())
                        .dynamicFont(.systemFont(ofSize: 14, weight: .bold))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                        .frame(width: width * 0.3, height: height)
                        .background(
                            Rectangle()
                                .fill(ColorAssets.primaryGreen200.swiftUIColor)
                        )
                        .onPress {}
                }
                .cornerRadius(8)
                .shadow(color: .black.opacity(0.15), radius: 1, x: 0, y: 2)
            }
            .height(52)
            .padding(.horizontal, 57)
            .padding(.top, -15)

            HStack {
                Text(L10n.sendInviteLink)
            }
            .frame(maxWidth: .infinity)
            .height(52)
            .padding(.horizontal, 16)
            .dynamicFont(.systemFont(ofSize: 14, weight: .medium))
            .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            .background(ColorAssets.primaryGreen.swiftUIColor)
            .cornerRadius(5)
            .padding(.horizontal, 16)
            .onPress {}

            VStack(spacing: 0) {
                Text(L10n.howToRefer)
                    .dynamicFont(.systemFont(ofSize: 14, weight: .medium))
                ImageAssets.icArrowRight.swiftUIImage
                    .rotationEffect(.degrees(90))
            }
            .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
        }
    }

    private func stepInviteView() -> some View {
        LazyVGrid(columns: [.flexible(), .flexible()], spacing: 20) {
            ForEach(StepInvite.allCases, id: \.self) { item in
                VStack {
                    item.image
                        .resizable()
                        .frame(width: 98, height: 98)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.15), radius: 1, x: 0, y: 2)
                    Text(item.title)
                        .dynamicFont(.systemFont(ofSize: 22, weight: .medium))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                    Text(item.description)
                        .dynamicFont(.systemFont(ofSize: 12))
                        .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding(.horizontal, 16)
    }

    private func footerView() -> some View {
        Text(L10n.inviteNotes)
            .dynamicFont(.systemFont(ofSize: 14, weight: .medium))
            .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 26)
    }
}

// MARK: InviteFriendsView.StepInvite

extension InviteFriendsView {
    enum StepInvite: Int, CaseIterable {
        case step1 = 1, step2 = 2, step3 = 3, step4 = 4

        var title: String {
            switch self {
            case .step1: return "01"
            case .step2: return "02"
            case .step3: return "03"
            case .step4: return "04"
            }
        }

        var description: String {
            switch self {
            case .step1: return "Send invitation link\nJust tap the button!"
            case .step2: return "Invite link to friend\nwill be sent"
            case .step3: return "Via the link sent to you\nProceed to membership registration"
            case .step4: return "When all courses are completed\nFriends and I also\nearn 1,000P!"
            }
        }

        var image: Image {
            switch self {
            case .step1: return ImageAssets.inviteStep1.swiftUIImage
            case .step2: return ImageAssets.inviteStep2.swiftUIImage
            case .step3: return ImageAssets.inviteStep3.swiftUIImage
            case .step4: return ImageAssets.inviteStep4.swiftUIImage
            }
        }
    }
}
