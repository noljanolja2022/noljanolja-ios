//
//  ContactModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 06/03/2023.
//

import Contacts
import Foundation
import UIKit

struct ContactModel {
    let id: String
    let name: String
    let phone: [String]
    let image: UIImage?

    init(_ contact: CNContact) {
        self.id = contact.identifier
        self.name = CNContactFormatter.string(from: contact, style: .fullName) ?? ""
        self.phone = contact.phoneNumbers.map { $0.value.stringValue }
        self.image = contact.imageData.flatMap { UIImage(data: $0) }
    }
}
