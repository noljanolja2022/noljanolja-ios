//
//  StickerAPI.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 26/03/2023.
//

import Combine
import Foundation
import Moya

// MARK: - MediaTargets

private enum MediaTargets {
    struct GetStickerPacks: BaseAuthTargetType {
        var path: String { "v1/media/sticker-packs" }
        var method: Moya.Method { .get }
        var task: Task {
            .requestPlain
        }
    }

    struct DownloadStickerPacks: BaseAuthTargetType {
        var path: String { "v1/media/sticker-packs/\(id)" }
        var method: Moya.Method { .get }
        var task: Task {
            .downloadDestination { _, _ in
                (destinationURL, [.removePreviousFile, .createIntermediateDirectories])
            }
        }

        let id: Int
        let destinationURL: URL
    }
}

// MARK: - MediaNetworkRepository

protocol MediaNetworkRepository {
    func getStickerPacks() -> AnyPublisher<[StickerPack], Error>
    func downloadStickerPack(id: Int, downloadURL: URL) -> AnyPublisher<Void, Error>
    func getStickerURL(stickerPackID: Int, stickerFile: String) -> URL?
    func getStickerURL(stickerPath: String) -> URL?
}

// MARK: - MediaNetworkRepositoryImpl

final class MediaNetworkRepositoryImpl: MediaNetworkRepository {
    static let `default` = MediaNetworkRepositoryImpl()

    private let api: ApiType

    private init(api: ApiType = Api.default) {
        self.api = api
    }

    func getStickerPacks() -> AnyPublisher<[StickerPack], Error> {
        api.request(
            target: MediaTargets.GetStickerPacks(),
            atKeyPath: "data"
        )
    }

    func downloadStickerPack(id: Int, downloadURL: URL) -> AnyPublisher<Void, Error> {
        api.request(
            target: MediaTargets.DownloadStickerPacks(id: id, destinationURL: downloadURL)
        )
    }

    func getStickerURL(stickerPackID: Int, stickerFile: String) -> URL? {
        let string = NetworkConfigs.BaseUrl.baseUrl + "/v1/media/sticker-packs/\(stickerPackID)/\(stickerFile)"
        return URL(string: string)
    }

    func getStickerURL(stickerPath: String) -> URL? {
        let string = NetworkConfigs.BaseUrl.baseUrl + "/v1/media/sticker-packs/\(stickerPath)"
        return URL(string: string)
    }
}
