//
//  StorableContact.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/03/2023.
//

import Foundation
import RealmSwift

class StorableUser: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String?

    var user: User {
        User(id: id, name: name)
    }

    convenience init(_ user: User) {
        self.init()
        self.id = user.id
        self.name = user.name
    }
}
