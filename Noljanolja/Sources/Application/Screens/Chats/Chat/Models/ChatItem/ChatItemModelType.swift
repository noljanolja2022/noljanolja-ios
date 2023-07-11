//
//  MessageItemType.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 13/03/2023.
//

import Foundation

enum ChatItemModelType: Equatable {
    case date(DateChatItemModel)
    case message(MessageChatItemModel)

    static var viewIdPrefix: String {
        String(describing: Self.self)
    }
}
