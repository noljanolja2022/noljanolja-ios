//
//  Realm+Init.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/03/2023.
//

import Foundation
import RealmSwift

extension Realm {
    static let `default`: Realm = {
        let realm = try! Realm()
        return realm
    }()
}
