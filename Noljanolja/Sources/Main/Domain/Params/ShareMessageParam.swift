//
//  ShareMessageParam.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 28/07/2023.
//

import Foundation

struct ShareMessageParam: Equatable {
    let type: MessageType
    let message: String?
    let attachments: [AttachmentParam]?
    let shareMessageID: Int?
    let replyToMessageID: Int?
    let shareVideoID: String?
    let conversationIDs: [Int]
}
