//
//  VideoKeywordLocalRepository.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 26/07/2023.
//

import Combine
import Foundation
import RealmSwift

// MARK: - VideoKeywordLocalRepository

protocol VideoKeywordLocalRepository {
    func saveKeyword(_ keyword: VideoKeyword)
    func observeKeywords(_ string: String) -> AnyPublisher<[VideoKeyword], Error>
    func delete(_ keyword: VideoKeyword)
    func deleteAll()
}

// MARK: - VideoKeywordLocalRepositoryImpl

final class VideoKeywordLocalRepositoryImpl: VideoKeywordLocalRepository {
    static let shared = VideoKeywordLocalRepositoryImpl()

    private lazy var realmManager: RealmManagerType = {
        let id = "video_keyword"
        return RealmManager(
            configuration: {
                var config = Realm.Configuration.defaultConfiguration
                config.fileURL?.deleteLastPathComponent()
                config.fileURL?.appendPathComponent(id)
                config.fileURL?.appendPathExtension("realm")
                return config
            }(),
            queue: DispatchQueue(label: "realm.\(id)", qos: .default)
        )
    }()

    private init() {}

    func saveKeyword(_ keyword: VideoKeyword) {
        let storableCouponKeyword = StorableVideoKeyword(keyword)
        realmManager.add(storableCouponKeyword, update: .all)
    }

    func observeKeywords(_ string: String) -> AnyPublisher<[VideoKeyword], Error> {
        Just(())
            .setFailureType(to: Error.self)
            .receive(on: DispatchQueue.main) // TODO: Can only add notification blocks from within runloops
            .flatMapLatest { [weak self] _ -> AnyPublisher<[VideoKeyword], Error> in
                guard let self else {
                    return Empty<[VideoKeyword], Error>().eraseToAnyPublisher()
                }
                return self.realmManager.objects(StorableVideoKeyword.self)
                    .collectionPublisher
                    .map { keywords -> [VideoKeyword] in
                        keywords
                            .compactMap { $0.model }
                            .filter {
                                if string.isEmpty {
                                    return true
                                } else {
                                    return $0.keyword.lowercased().contains(string.lowercased())
                                }
                            }
                            .sorted { $0.createdAt > $1.createdAt }
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    func delete(_ keyword: VideoKeyword) {
        guard let keyword = realmManager.object(ofType: StorableVideoKeyword.self, forPrimaryKey: keyword.keyword) else {
            return
        }
        realmManager.delete(keyword)
    }

    func deleteAll() {
        realmManager.deleteAll()
    }
}
