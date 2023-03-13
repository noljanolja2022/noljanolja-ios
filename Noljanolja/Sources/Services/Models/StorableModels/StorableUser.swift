//
//  StorableContact.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/03/2023.
//

import Foundation
import RealmSwift

class StorableUser: Object, StorableModel {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String?
    @Persisted var avatar: String?
    @Persisted var phone: String?
    @Persisted var email: String?
    @Persisted var isEmailVerified = false
    @Persisted var pushToken: String?
    @Persisted var dob: String?
    @Persisted var gender: String?

    var model: User? {
        User(
            id: id,
            name: name,
            avatar: avatar,
            phone: phone,
            email: email,
            isEmailVerified: isEmailVerified,
            pushToken: pushToken,
            dob: dob,
            gender: gender
        )
    }

    required convenience init(_ model: User) {
        self.init()
        self.id = model.id
        self.name = model.name
        self.avatar = model.avatar
        self.phone = model.phone
        self.email = model.email
        self.isEmailVerified = model.isEmailVerified
        self.dob = model.dob
        self.gender = model.gender
    }
}
