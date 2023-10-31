//
//  StickerPack.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 26/03/2023.
//

import Foundation

// MARK: - StickerPack

struct StickerPack: Equatable, Codable {
    let id: Int
    let name: String?
    let publisher: String?
    let trayImageFile: String
    let isAnimated: Bool
    let stickers: [Sticker]

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case publisher
        case trayImageFile
        case isAnimated
        case stickers
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.publisher = try container.decodeIfPresent(String.self, forKey: .publisher)
        self.trayImageFile = try container.decodeIfPresent(String.self, forKey: .trayImageFile) ?? ""
        self.isAnimated = try container.decodeIfPresent(Bool.self, forKey: .isAnimated) ?? false
        self.stickers = try container.decodeIfPresent([Sticker].self, forKey: .stickers) ?? []
    }

    init(id: Int, name: String?, publisher: String?, trayImageFile: String, isAnimated: Bool, stickers: [Sticker]) {
        self.id = id
        self.name = name
        self.publisher = publisher
        self.trayImageFile = trayImageFile
        self.isAnimated = isAnimated
        self.stickers = stickers
    }

    func getImageURL() -> URL? {
        MediaUseCasesImpl.default.getStickerURL(stickerPackID: id, stickerFile: trayImageFile)
    }
}
