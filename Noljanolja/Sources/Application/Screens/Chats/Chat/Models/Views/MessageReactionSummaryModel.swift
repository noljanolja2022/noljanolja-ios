//
//  MessageReactionSummaryModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 26/06/2023.
//

import Foundation

struct MessageReactionSummaryModel: Equatable {
    let reactIcons: [ReactIcon]
    let count: Int

    init?(_ models: [MessageReaction]) {
        guard !models.isEmpty else { return nil }
        let reactIconSet = models.reduce(Set<ReactIcon>()) { result, item in
            var result = result
            result.insert(ReactIcon(item))
            return result
        }
        self.reactIcons = Array(reactIconSet)
        self.count = models.count
    }
}
