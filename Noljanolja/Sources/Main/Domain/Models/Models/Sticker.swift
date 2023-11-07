//
//  Sticker.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 26/03/2023.
//

import Foundation

// MARK: - Sticker

struct Sticker: Equatable, Codable {
    let imageFile: String
    let emojis: [String]

    enum CodingKeys: String, CodingKey {
        case imageFile
        case emojis
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.imageFile = try container.decode(String.self, forKey: .imageFile)
        self.emojis = try container.decode([String].self, forKey: .emojis)
    }

    init(imageFile: String, emojis: [String]) {
        self.imageFile = imageFile
        self.emojis = emojis
    }

    func getImageURL(_ stickerPackID: Int) -> URL? {
        MediaUseCasesImpl.default.getStickerURL(stickerPackID: stickerPackID, stickerFile: imageFile)
    }
}
