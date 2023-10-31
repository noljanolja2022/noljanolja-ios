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

    private let networkMediaRepository: NetworkMediaRepository
    private let localMediaRepository: LocalMediaRepository

    private init(networkMediaRepository: NetworkMediaRepository = NetworkMediaRepositoryImpl.default,
                 localMediaRepository: LocalMediaRepository = LocalMediaRepositoryImpl.default) {
        self.networkMediaRepository = networkMediaRepository
        self.localMediaRepository = localMediaRepository
    }

    func getStickerPacks() -> AnyPublisher<[StickerPack], Error> {
        let localStickerPacks = localMediaRepository.observeStickerPacks()
            .filter { !$0.isEmpty }

        let remoteStickerPacks = networkMediaRepository
            .getStickerPacks()
            .handleEvents(receiveOutput: { [weak self] in
                self?.localMediaRepository.saveStickerPacks($0)
            })

        return Publishers.Merge(localStickerPacks, remoteStickerPacks)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    func downloadStickerPack(id: Int) -> AnyPublisher<Void, Error> {
        let downloadURL = localMediaRepository.generateDownloadStickerPackURL(id: id)
        return networkMediaRepository.downloadStickerPack(id: id, downloadURL: downloadURL)
            .tryMap { [weak self] _ in
                try self?.localMediaRepository.saveStickerPack(id: id, source: downloadURL)
            }
            .eraseToAnyPublisher()
    }

    func getLocalStickerPackURL(id: Int) -> URL? {
        localMediaRepository.getStickerPackURL(id: id)
    }

    func getStickerURL(stickerPackID: Int, stickerFile: String) -> URL? {
        let localStickerURL = localMediaRepository.getStickerURL(stickerPackID: stickerPackID, stickerFile: stickerFile)
        let remoteStickerURL = networkMediaRepository.getStickerURL(stickerPackID: stickerPackID, stickerFile: stickerFile)
        return localStickerURL ?? remoteStickerURL
    }

    func getStickerURL(stickerPath: String) -> URL? {
        let localStickerURL = localMediaRepository.getStickerURL(stickerPath: stickerPath)
        let remoteStickerURL = networkMediaRepository.getStickerURL(stickerPath: stickerPath)
        return localStickerURL ?? remoteStickerURL
    }
}
