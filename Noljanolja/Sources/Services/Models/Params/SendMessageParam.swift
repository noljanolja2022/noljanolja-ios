//
//  SendMessageParam.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 28/03/2023.
//

import Foundation

struct SendMessageParam: Equatable {
    let currentUser: User
    let localID: String
    let conversationID: Int
    let type: MessageType
    let message: String?
    let attachments: [AttachmentParam]?
    let shareMessage: Message?
    let replyToMessage: Message?
}
