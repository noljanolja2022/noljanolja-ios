//
//  MessageSctionByDate.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 13/03/2023.
//

import Foundation

struct DateChatItemModel: Equatable {
    let message: String

    init(message: Message) {
        self.message = message.createdAt.relativeFormatForMessage()
    }
}
