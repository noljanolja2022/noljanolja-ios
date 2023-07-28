//
//  StorableVideoCommenter.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 28/07/2023.
//

import Foundation
import RealmSwift

final class StorableVideoCommenter: Object {
    @Persisted var name: String?
    @Persisted var avatar: String?

    var model: VideoCommenter? {
        VideoCommenter(
            name: name,
            avatar: avatar
        )
    }

    required convenience init(_ model: VideoCommenter) {
        self.init()
        self.name = model.name
        self.avatar = model.avatar
    }
}
