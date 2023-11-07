//
//  PromotedVideo.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 18/09/2023.
//

import Foundation

struct PromotedVideo: Equatable, Codable {
    let id: Int
    let autoPlay: Bool
    let autoLike: Bool
    let autoComment: Bool
    let autoSubscribe: Bool
    let video: Video?

    enum CodingKeys: String, CodingKey {
        case id
        case autoPlay
        case autoLike
        case autoComment
        case autoSubscribe
        case video
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.autoPlay = try container.decodeIfPresent(Bool.self, forKey: .autoPlay) ?? false
        self.autoLike = try container.decodeIfPresent(Bool.self, forKey: .autoLike) ?? false
        self.autoComment = try container.decodeIfPresent(Bool.self, forKey: .autoComment) ?? false
        self.autoSubscribe = try container.decodeIfPresent(Bool.self, forKey: .autoSubscribe) ?? false
        self.video = try container.decodeIfPresent(Video.self, forKey: .video)
    }
}
