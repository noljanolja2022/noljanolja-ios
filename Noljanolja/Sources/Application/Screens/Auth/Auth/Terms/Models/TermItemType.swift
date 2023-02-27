//
//  TermItemModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/02/2023.
//

import Foundation
import SwifterSwift
import SwiftUI

// MARK: - TermItemType

enum TermItemType: Int, CaseIterable {
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

    var content: String {
        switch self {
        case .termOfService:
            return """
            In the hills of North Gando, however, I see winter as one of the girls. It seems like loneliness and longing and pride that has passed. One of the buried cars has a name like this and the name of Maria. I have an exotic night on top of my desk one by one. Loneliness and foreign land fell, my mother, and love in one. In one, I see the stars, and the grave inside is mine. That's why it's named so much now in North Gando. Now, the baby star, Francis star, seems to be on the desk. I threw away the name that came out, and the people who came down like a horse blooming. My loneliness, my mother, and my worries are all because of Hale.

            Look at the name of the horse in one of the deer, sleep, and one baby. Francis of the genus fell and is still on top. The name and above, also sleeps in the heart, I am a rabbit, hill Maria mother, there is. That's why I call it one of my own. There is a night in the baby's chest. Why is it easy, rabbit, and name, name, and two. For a hill desk, look engraved. It's because of the loneliness that mourns over Maria's autumn and now the starlight is shining. Wrote the stars to worm, there is no one who cries tomorrow. It is the reason for the loneliness and loneliness of the buried star neighbor.

            It's a beautiful thing that is engraved asurahi shui. Loneliness and Poetry and Hale People's dirt, roe deer, children's stars seem far away. heal the wounds Is there no one anywhere? it's beautiful outside Loneliness and Poetry and Hale People's dirt, roe deer, children's stars seem far away. heal the wounds Is there no one anywhere? Is there no one anywhere?
            """
        case .mainAge:
            return """
            Look at the name of the horse in one of the deer, sleep, and one baby. Francis of the genus fell and is still on top. The name and above, also sleeps in the heart, I am a rabbit, hill Maria mother, there is. That's why I call it one of my own. There is a night in the baby's chest. Why is it easy, rabbit, and name, name, and two. For a hill desk, look engraved. It's because of the loneliness that mourns over Maria's autumn and now the starlight is shining. Wrote the stars to worm, there is no one who cries tomorrow. It is the reason for the loneliness and loneliness of the buried star neighbor.

            It's a beautiful thing that is engraved asurahi shui. Loneliness and Poetry and Hale People's dirt, roe deer, children's stars seem far away. heal the wounds Is there no one anywhere? it's beautiful outside Loneliness and Poetry and Hale People's dirt, roe deer, children's stars seem far away. heal the wounds Is there no one anywhere? Is there no one anywhere?
            """
        case .personalInfo:
            return """
            It's a beautiful thing that is engraved asurahi shui. Loneliness and Poetry and Hale People's dirt, roe deer, children's stars seem far away. heal the wounds Is there no one anywhere? it's beautiful outside Loneliness and Poetry and Hale People's dirt, roe deer, children's stars seem far away. heal the wounds Is there no one anywhere? Is there no one anywhere?
            """
        case .receiveMarketingInfo:
            return """
            In the hills of North Gando, however, I see winter as one of the girls. It seems like loneliness and longing and pride that has passed. One of the buried cars has a name like this and the name of Maria. I have an exotic night on top of my desk one by one. Loneliness and foreign land fell, my mother, and love in one. In one, I see the stars, and the grave inside is mine. That's why it's named so much now in North Gando. Now, the baby star, Francis star, seems to be on the desk. I threw away the name that came out, and the people who came down like a horse blooming. My loneliness, my mother, and my worries are all because of Hale.
            """
        }
    }

    var isSeparatoRequired: Bool {
        switch self {
        case .personalInfo: return true
        case .termOfService, .mainAge, .receiveMarketingInfo: return false
        }
    }
}

extension [TermItemType] {
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
