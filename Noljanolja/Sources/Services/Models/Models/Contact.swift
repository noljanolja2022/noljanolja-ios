//
//  Contact.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 06/03/2023.
//

import Contacts
import Foundation
import UIKit

struct Contact: Codable {
    let name: String
    let emails: [String]
    let phones: [String]

    init(_ contact: CNContact) {
        self.name = CNContactFormatter.string(from: contact, style: .fullName) ?? ""
        self.emails = contact.emailAddresses.map { String($0.value) }
        self.phones = contact.phoneNumbers.map { $0.value.stringValue }
    }
}
