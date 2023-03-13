//
//  MessageItemType.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 13/03/2023.
//

import Foundation

enum ChatItemModelType: Equatable, Identifiable {
    case date(ChatDateItemModel)
    case item(ChatMessageItemModel)

    var id: String {
        switch self {
        case let .date(dateItemModel): return dateItemModel.id
        case let .item(messageItemModel): return String(messageItemModel.id)
        }
    }
}
