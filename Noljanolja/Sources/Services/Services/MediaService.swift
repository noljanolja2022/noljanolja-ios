//
//  MediaService.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 26/03/2023.
//

import Combine
import Foundation

// MARK: - MediaServiceType

protocol MediaServiceType {
    func getStickerPacks() -> AnyPublisher<[StickerPack], Error>
    func downloadStickerPack(id: Int) -> AnyPublisher<Void, Error>

    func getLocalStickerPackURL(id: Int) -> URL?

    func getStickerURL(stickerPackID: Int, stickerFile: String) -> URL?
    func getStickerURL(stickerPath: String) -> URL?
}

// MARK: - MediaService

final class MediaService: MediaServiceType {
    static let `default` = MediaService()

    private let mediaAPI: MediaAPIType
    private let mediaStore: MediaStoreType

    private init(mediaAPI: MediaAPIType = MediaAPI.default,
                 mediaStore: MediaStoreType = MediaStore.default) {
        self.mediaAPI = mediaAPI
        self.mediaStore = mediaStore
    }

    func getStickerPacks() -> AnyPublisher<[StickerPack], Error> {
        let localStickerPacks = mediaStore.observeStickerPacks()
            .filter { !$0.isEmpty }

        let remoteStickerPacks = mediaAPI
            .getStickerPacks()
            .handleEvents(receiveOutput: { [weak self] in
                self?.mediaStore.saveStickerPacks($0)
            })

        return Publishers.Merge(localStickerPacks, remoteStickerPacks)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    func downloadStickerPack(id: Int) -> AnyPublisher<Void, Error> {
        let downloadURL = mediaStore.generateDownloadStickerPackURL(id: id)
        return mediaAPI.downloadStickerPack(id: id, downloadURL: downloadURL)
            .tryMap { [weak self] _ in
                try self?.mediaStore.saveStickerPack(id: id, source: downloadURL)
            }
            .eraseToAnyPublisher()
    }

    func getLocalStickerPackURL(id: Int) -> URL? {
        mediaStore.getStickerPackURL(id: id)
    }

    func getStickerURL(stickerPackID: Int, stickerFile: String) -> URL? {
        let localStickerURL = mediaStore.getStickerURL(stickerPackID: stickerPackID, stickerFile: stickerFile)
        let remoteStickerURL = mediaAPI.getStickerURL(stickerPackID: stickerPackID, stickerFile: stickerFile)
        return localStickerURL ?? remoteStickerURL
    }

    func getStickerURL(stickerPath: String) -> URL? {
        let localStickerURL = mediaStore.getStickerURL(stickerPath: stickerPath)
        let remoteStickerURL = mediaAPI.getStickerURL(stickerPath: stickerPath)
        return localStickerURL ?? remoteStickerURL
    }
}
