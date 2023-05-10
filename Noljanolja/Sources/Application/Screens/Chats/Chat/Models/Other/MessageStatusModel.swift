//
//  SeenByType.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/05/2023.
//

import Foundation

// MARK: - MessageStatusModel

struct MessageStatusModel: Equatable {
    let statusType: StatusType
}

extension MessageStatusModel {
    enum StatusType: Equatable {
        case none
        case sending
        case sent
        case seen(SeenType)
    }

    enum SeenType: Equatable {
        case single(Bool)
        case group(Int)
        case none
    }
}
