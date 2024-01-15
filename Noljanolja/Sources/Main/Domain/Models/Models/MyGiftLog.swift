//
//  MyGiftLog.swift
//  Noljanolja
//
//  Created by Duy Dinh on 14/01/2024.
//

import Foundation

struct MyGiftLog: Equatable, Codable {
    var voucherRef: String?
    var voucherSettlementRef: String?
    var voucherName: String?
    var status: String?
    var expirationDate: String?
    var edenredUrl: String?
    var viewCode: String?
    var pinCode: String?
    var displayCodes: [String?]

    enum CodingKeys: String, CodingKey {
        case voucherRef = "voucher_ref"
        case voucherSettlementRef = "voucher_settlement_ref"
        case voucherName = "voucher_name"
        case status
        case expirationDate = "expiration_date"
        case edenredUrl = "edenred_url"
        case viewCode = "view_code"
        case pinCode = "pin_code"
        case displayCodes = "display_codes"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.voucherRef = try container.decodeIfPresent(String.self, forKey: .voucherRef)
        self.voucherSettlementRef = try container.decodeIfPresent(String.self, forKey: .voucherSettlementRef)
        self.voucherName = try container.decodeIfPresent(String.self, forKey: .voucherName)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
        self.expirationDate = try container.decodeIfPresent(String.self, forKey: .expirationDate)
        self.edenredUrl = try container.decodeIfPresent(String.self, forKey: .edenredUrl)
        self.viewCode = try container.decodeIfPresent(String.self, forKey: .viewCode)
        self.pinCode = try container.decodeIfPresent(String.self, forKey: .pinCode)
        self.displayCodes = try container.decodeIfPresent([String].self, forKey: .displayCodes) ?? []
    }
}
