//
//  TermItemModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/02/2023.
//

import Foundation
import SwifterSwift
import SwiftUI

// MARK: - TermAndCoditionItemType

enum TermAndCoditionItemType: Int, CaseIterable {
    case termOfService
    case mainAge
    case personalInfo
    case receiveMarketingInfo

    var title: String {
        switch self {
        case .termOfService, .mainAge, .personalInfo: return "[Essential]"
        case .receiveMarketingInfo: return "[Select]"
        }
    }

    var description: String {
        switch self {
        case .termOfService: return "Subscribe Terms of Service"
        case .mainAge: return "You are 14 years old or older."
        case .personalInfo: return "Collection, Use and Third Parties of Personal Information consent to provide"
        case .receiveMarketingInfo: return "Consent to receive marketing information"
        }
    }

    var isSeparatoRequired: Bool {
        switch self {
        case .personalInfo: return true
        case .termOfService, .mainAge, .receiveMarketingInfo: return false
        }
    }
}

extension [TermAndCoditionItemType] {
    func maxTitleWidth(with font: UIFont, defaultWidth: CGFloat = 72) -> CGFloat {
        let widths = map {
            let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: font.lineHeight)
            let boundingBox = $0.title.boundingRect(
                with: constraintRect,
                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                attributes: [.font: font],
                context: nil
            )
            let width = ceil(boundingBox.width)
            return CGFloat(width + 4)
        }
        return widths.max() ?? defaultWidth
    }
}
