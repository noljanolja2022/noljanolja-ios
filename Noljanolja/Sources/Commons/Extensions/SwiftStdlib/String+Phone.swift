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
}
