//
//  MediaUseCasesImpl.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 26/03/2023.
//

import Combine
import Foundation

// MARK: - MediaUseCases

protocol MediaUseCases {
    func getStickerPacks() -> AnyPublisher<[StickerPack], Error>
    func downloadStickerPack(id: Int) -> AnyPublisher<Void, Error>

    func getLocalStickerPackURL(id: Int) -> URL?

    func getStickerURL(stickerPackID: Int, stickerFile: String) -> URL?
    func getStickerURL(stickerPath: String) -> URL?
}

// MARK: - MediaUseCasesImpl

final class MediaUseCasesImpl: MediaUseCases {
    static let `default` = MediaUseCasesImpl()

    private let mediaNetworkRepository: MediaNetworkRepository
    private let mediaLocalRepository: MediaLocalRepository

    private init(mediaNetworkRepository: MediaNetworkRepository = MediaNetworkRepositoryImpl.default,
                 mediaLocalRepository: MediaLocalRepository = MediaLocalRepositoryImpl.default) {
        self.mediaNetworkRepository = mediaNetworkRepository
        self.mediaLocalRepository = mediaLocalRepository
    }

    func getStickerPacks() -> AnyPublisher<[StickerPack], Error> {
        let localStickerPacks = mediaLocalRepository.observeStickerPacks()
            .filter { !$0.isEmpty }

        let remoteStickerPacks = mediaNetworkRepository
            .getStickerPacks()
            .handleEvents(receiveOutput: { [weak self] in
                self?.mediaLocalRepository.saveStickerPacks($0)
            })

        return Publishers.Merge(localStickerPacks, remoteStickerPacks)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    func downloadStickerPack(id: Int) -> AnyPublisher<Void, Error> {
        let downloadURL = mediaLocalRepository.generateDownloadStickerPackURL(id: id)
        return mediaNetworkRepository.downloadStickerPack(id: id, downloadURL: downloadURL)
            .tryMap { [weak self] _ in
                try self?.mediaLocalRepository.saveStickerPack(id: id, source: downloadURL)
            }
            .eraseToAnyPublisher()
    }

    func getLocalStickerPackURL(id: Int) -> URL? {
        mediaLocalRepository.getStickerPackURL(id: id)
    }

    func getStickerURL(stickerPackID: Int, stickerFile: String) -> URL? {
        let localStickerURL = mediaLocalRepository.getStickerURL(stickerPackID: stickerPackID, stickerFile: stickerFile)
        let remoteStickerURL = mediaNetworkRepository.getStickerURL(stickerPackID: stickerPackID, stickerFile: stickerFile)
        return localStickerURL ?? remoteStickerURL
    }

    func getStickerURL(stickerPath: String) -> URL? {
        let localStickerURL = mediaLocalRepository.getStickerURL(stickerPath: stickerPath)
        let remoteStickerURL = mediaNetworkRepository.getStickerURL(stickerPath: stickerPath)
        return localStickerURL ?? remoteStickerURL
    }
}
