//
//  StickerAPI.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 26/03/2023.
//

import Combine
import Foundation
import Moya

// MARK: - MediaAPITargets

private enum MediaAPITargets {
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

// MARK: - MediaAPIType

protocol MediaAPIType {
    func getStickerPacks() -> AnyPublisher<[StickerPack], Error>
    func downloadStickerPack(id: Int, downloadURL: URL) -> AnyPublisher<Void, Error>
    func getStickerURL(stickerPackID: Int, stickerFile: String) -> URL?
    func getStickerURL(stickerPath: String) -> URL?
}

// MARK: - MediaAPI

final class MediaAPI: MediaAPIType {
    static let `default` = MediaAPI()

    private let api: ApiType

    private init(api: ApiType = Api.default) {
        self.api = api
    }

    func getStickerPacks() -> AnyPublisher<[StickerPack], Error> {
        api.request(
            target: MediaAPITargets.GetStickerPacks(),
            atKeyPath: "data"
        )
    }

    func downloadStickerPack(id: Int, downloadURL: URL) -> AnyPublisher<Void, Error> {
        api.request(
            target: MediaAPITargets.DownloadStickerPacks(id: id, destinationURL: downloadURL)
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
