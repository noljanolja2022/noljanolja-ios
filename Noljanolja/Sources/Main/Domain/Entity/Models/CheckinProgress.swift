//
//  CheckinProgress.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 31/07/2023.
//

import Foundation

struct CheckinProgress: Equatable, Decodable {
    let day: Date
    let rewardPoints: Int

    var isCompleted: Bool {
        rewardPoints > 0
    }

    enum CodingKeys: CodingKey {
        case day
        case rewardPoints
        case isCompleted
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.day = try {
            let dayString = try container.decodeIfPresent(String.self, forKey: .day)
            if let day = dayString?.date(timeZone: TimeZone(identifier: "UTC"), withFormat: "yyyy-MM-dd") {
                return day
            } else {
                throw DecodingError.valueNotFound(
                    String.self,
                    DecodingError.Context(
                        codingPath: container.codingPath + [CodingKeys.day],
                        debugDescription: ""
                    )
                )
            }
        }()
        self.rewardPoints = try container.decodeIfPresent(Int.self, forKey: .rewardPoints) ?? 0
    }
}
