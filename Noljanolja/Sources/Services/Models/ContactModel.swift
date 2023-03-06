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
    let image: UIImage?
    let name: String?

    init(_ contact: CNContact) {
        self.id = contact.identifier
        self.image = contact.imageData.flatMap { UIImage(data: $0) }
        self.name = CNContactFormatter.string(from: contact, style: .fullName)
    }
}
