//
//  ConversationAttachmentType.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 30/08/2023.
//

import Foundation

enum ConversationAttachmentType: String, Equatable {
    case photo = "PHOTO"
    case file = "FILE"
    case link = "LINK"

    var title: String {
        switch self {
        case .photo: return "Images, Videos"
        case .file: return "Files"
        case .link: return "Links"
        }
    }
}
