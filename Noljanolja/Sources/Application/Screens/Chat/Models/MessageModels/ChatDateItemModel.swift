//
//  MessageSctionByDate.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 13/03/2023.
//

import Foundation

struct ChatDateItemModel: Equatable, Identifiable {
    let date: Date

    var id: String {
        date.string(withFormat: NetworkConfigs.Format.apiDateFormat)
    }

    var displayDateString: String {
        date.relativeString("EEEE, dd MMM, yyyy")
    }

    init(date: Date) {
        self.date = date
    }

    init(message: Message) {
        self.date = message.createdAt
    }
}
