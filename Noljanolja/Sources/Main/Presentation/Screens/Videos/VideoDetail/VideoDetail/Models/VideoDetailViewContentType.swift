//
//  VideoDetailViewState.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 14/09/2023.
//

import Foundation
import UIKit

enum VideoDetailViewContentType: Int, CaseIterable, Equatable {
    case full = 0
    case bottom
    case pictureInPicture
    case hide

    var playerWidth: CGFloat {
        switch self {
        case .full:
            return UIScreen.main.bounds.width
        case .bottom:
            return UIScreen.main.bounds.width / 3.5
        case .pictureInPicture:
            return UIScreen.main.bounds.width
        case .hide:
            return 0
        }
    }

    var playerHeight: CGFloat {
        playerWidth * (5.0 / 9.0)
    }
}
