//
//  String+FormattedPhone.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 12/03/2023.
//

import Foundation
import PhoneNumberKit

extension String {
    func formatPhone(type: PhoneNumberFormat = .e164) -> String? {
        let phoneNumberKit = PhoneNumberKit()
        let phoneNumber = try? phoneNumberKit.parse(self, ignoreType: true)
        return phoneNumber.flatMap { phoneNumberKit.format($0, toType: type) }
    }

    var phoneNumber: PhoneNumber? {
        let phoneNumberKit = PhoneNumberKit()
        return try? phoneNumberKit.parse(self, ignoreType: true)
    }

    var isValidPhoneNumber: Bool {
        PhoneNumberKit().isValidPhoneNumber(self)
    }

    var isValidName: Bool {
        let regex = "^[\\p{L}a-zA-Z0-9_-]"
        return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }

    var isValidEmail: Bool {
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
}
