//
//  ListSocialView.swift
//  Noljanolja
//
//  Created by duydinhv on 10/11/2023.
//

import SwiftUI

// MARK: - ListSocialView

struct ListSocialView: View {
    var onTap: (String) -> Void
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 30) {
                ForEach(ShareSocial.allCases, id: \.self) { item in
                    item.image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                        .onTapGesture {
                            onTap(item.schemaURL)
                        }
                }
            }
            .padding(.horizontal, 18)
        }
        .padding(.top, 12)
        .background(ColorAssets.neutralLight.swiftUIColor)
    }
}

// MARK: - ListSocialView_Previews

struct ListSocialView_Previews: PreviewProvider {
    static var previews: some View {
        ListSocialView(onTap: { _ in })
    }
}

// MARK: - ShareSocial

enum ShareSocial: CaseIterable {
    case facebook, twitter, messenger, telegram, whatapps

    var image: Image {
        switch self {
        case .facebook:
            return ImageAssets.icFacebook.swiftUIImage
        case .messenger:
            return ImageAssets.icMessenger.swiftUIImage
        case .twitter:
            return ImageAssets.icTwitter.swiftUIImage
        case .telegram:
            return ImageAssets.icTelegram.swiftUIImage
        case .whatapps:
            return ImageAssets.icWhatapps.swiftUIImage
        }
    }

    var schemaURL: String {
        switch self {
        case .facebook:
            return "https://www.facebook.com/sharer.php?u="
        case .twitter:
            return "twitter://post?message="
        case .messenger:
            return "fb-messenger://share?link="
        case .whatapps:
            return "whatsapp://send?text="
        case .telegram:
            return "tg://msg_url?url="
        }
    }
}
