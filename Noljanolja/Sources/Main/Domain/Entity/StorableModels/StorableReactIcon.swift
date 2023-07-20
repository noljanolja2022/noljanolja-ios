//
//  StorableReactIcon.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 21/06/2023.
//

import Foundation
import RealmSwift

// MARK: - StorableUser

final class StorableReactIcon: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var code: String?
    @Persisted var ractIconDescription: String?

    var model: ReactIcon? {
        ReactIcon(id: id, code: code, description: ractIconDescription)
    }

    required convenience init(_ model: ReactIcon) {
        self.init()
        self.id = model.id
        self.code = model.code
        self.ractIconDescription = model.description
    }

    override static func primaryKey() -> String? {
        "id"
    }
}
