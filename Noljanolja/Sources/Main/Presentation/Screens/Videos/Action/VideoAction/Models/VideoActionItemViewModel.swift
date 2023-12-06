//
//  VideoActionItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 27/07/2023.
//

import Foundation

enum VideoActionItemViewModel: CaseIterable {
    case share
    case copyLink
    case ignore

    var imageName: String {
        switch self {
        case .share: return ImageAssets.icShare.name
        case .copyLink: return ImageAssets.icLink.name
        case .ignore: return ImageAssets.icIgnore.name
        }
    }

    var title: String {
        switch self {
        case .share: return "Share Video"
        case .copyLink: return "Copy link"
        case .ignore: return "Ignore Video"
        }
    }
}
