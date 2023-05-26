//
//  MessageContentBackgroundModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 26/05/2023.
//

import Foundation
import UIKit

extension MessageContentBackgroundModel {
    enum BackgroundType: Equatable {
        case bubble(BubbleBackgroundModel)
        case cornerRadius(CornerRadiusBackgroundModel)
    }

    struct BubbleBackgroundModel: Equatable {}

    struct CornerRadiusBackgroundModel: Equatable {}

    struct RectCorner: Equatable {
        let rectCorner: UIRectCorner
        let radius: CGFloat
    }
}

// MARK: - MessageContentBackgroundModel

struct MessageContentBackgroundModel: Equatable {
    let type: BackgroundType
    let color: String
    let rotationAngle: Double
}
