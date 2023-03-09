//
//  StorableMessage.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//

import Foundation
import RealmSwift

final class StorableMessage: Object, StorableModel {
    @Persisted var message: String?
    
    var model: Message? {
        Message(message: message)
    }
    
    required convenience init(_ model: Message) {
        self.init()
        self.message = model.message
    }
}
