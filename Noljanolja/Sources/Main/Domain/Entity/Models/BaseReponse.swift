//
//  BaseReponse.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 24/07/2023.
//

import Foundation

struct BaseResponse: Decodable {
    let code: Int
    let message: String

    enum CodingKeys: CodingKey {
        case code
        case message
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decode(Int.self, forKey: .code)
        self.message = try container.decode(String.self, forKey: .message)
    }
}
