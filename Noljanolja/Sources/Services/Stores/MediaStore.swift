//
//  FileManagerAPI.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 26/03/2023.
//

import Combine
import Foundation
import RealmSwift
import Zip

// MARK: - MediaStoreType

protocol MediaStoreType {
    func saveStickerPacks(_ stickerPacks: [StickerPack])
    func observeStickerPacks() -> AnyPublisher<[StickerPack], Error>
    
    func generateDownloadStickerPackURL(id: Int) -> URL
    func saveStickerPack(id: Int, source: URL) throws

    func getStickerPackURL(id: Int) -> URL?
    func getStickerURL(stickerPackID: Int, stickerFile: String) -> URL?
    func getStickerURL(stickerPath: String) -> URL?
}

// MARK: - MediaStore

final class MediaStore: MediaStoreType {
    static let `default` = MediaStore()

    private lazy var realmManager: RealmManagerType = RealmManager(
        configuration: {
            var config = Realm.Configuration.defaultConfiguration
            config.fileURL?.deleteLastPathComponent()
            config.fileURL?.appendPathComponent("media")
            config.fileURL?.appendPathExtension("realm")
            return config
        }(),
        queue: DispatchQueue(label: "realm.media", qos: .default)
    )

    private init() {}

    func saveStickerPacks(_ stickerPacks: [StickerPack]) {
        let storableStickerPacks = stickerPacks.map { StorableStickerPack($0) }
        realmManager.add(storableStickerPacks, update: .all)
    }

    func observeStickerPacks() -> AnyPublisher<[StickerPack], Error> {
        realmManager.objects(StorableStickerPack.self)
            .collectionPublisher
            .map { stickerPacks -> [StickerPack] in stickerPacks.compactMap { $0.model } }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func generateDownloadStickerPackURL(id: Int) -> URL {
        let directories = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)
        let directory = directories[0]
        let stickerPacksDirectory = directory.appendingPathComponent("sticker_packs/download")
        let stickerFile = stickerPacksDirectory.appendingPathComponent("\(id)").appendingPathExtension("zip")
        return stickerFile
    }

    func saveStickerPack(id: Int, source: URL) throws {
        let destination = generateStickerPackURL(id)
        try Zip.unzipFile(source, destination: destination, overwrite: true, password: nil)
    }

    func getStickerPackURL(id: Int) -> URL? {
        let stickerPacksURL = generateStickerPacksURL()
        let stickerPackURL = stickerPacksURL.appendingPathComponent("\(id)")

        if FileManager.default.fileExists(atPath: stickerPackURL.path) {
            return stickerPackURL
        } else {
            return nil
        }
    }

    func getStickerURL(stickerPackID: Int, stickerFile: String) -> URL? {
        let stickerPackURL = generateStickerPackURL(stickerPackID)
        let stickerURL = stickerPackURL.appendingPathComponent(stickerFile)
        if FileManager.default.fileExists(atPath: stickerURL.path) {
            return stickerURL
        } else {
            return nil
        }
    }

    func getStickerURL(stickerPath: String) -> URL? {
        let directories = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let directory = directories[0]
        let stickerPacksDirectory = directory.appendingPathComponent("sticker_packs")
        let stickerURL = stickerPacksDirectory.appendingPathComponent(stickerPath)
        if FileManager.default.fileExists(atPath: stickerURL.path) {
            return stickerURL
        } else {
            return nil
        }
    }
}

extension MediaStore {
    private func generateStickerPacksURL() -> URL {
        let directories = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let directory = directories[0]
        let stickerPacksURL = directory.appendingPathComponent("sticker_packs")
        return stickerPacksURL
    }

    private func generateStickerPackURL(_ id: Int) -> URL {
        let getStickerPacksURL = generateStickerPacksURL()
        let stickerPackURL = getStickerPacksURL.appendingPathComponent("\(id)")
        return stickerPackURL
    }
}
