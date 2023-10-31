//
//  CheckinRepository.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 31/07/2023.
//

import Combine
import Foundation
import Moya

// MARK: - NetworkCheckinTargets

private enum NetworkCheckinTargets {
    struct DailyCheckin: BaseAuthTargetType {
        var path: String { "v1/users/me/checkin" }
        let method: Moya.Method = .post
        var task: Task { .requestPlain }
    }

    struct GetCheckinProgresses: BaseAuthTargetType {
        var path: String { "v1/users/me/checkin-progresses" }
        let method: Moya.Method = .get
        var task: Task { .requestPlain }
    }
}

// MARK: - NetworkCheckinRepository

protocol NetworkCheckinRepository {
    func dailyCheckin() -> AnyPublisher<String, Error>
    func getCheckinProgresses() -> AnyPublisher<[CheckinProgress], Error>
}

// MARK: - NetworkCheckinRepositoryImpl

final class NetworkCheckinRepositoryImpl: NetworkCheckinRepository {
    static let shared = NetworkCheckinRepositoryImpl()

    private let api: ApiType

    init(api: ApiType = Api.default) {
        self.api = api
    }

    func dailyCheckin() -> AnyPublisher<String, Error> {
        api.request(
            target: NetworkCheckinTargets.DailyCheckin(),
            atKeyPath: "message"
        )
    }

    func getCheckinProgresses() -> AnyPublisher<[CheckinProgress], Error> {
        api.request(
            target: NetworkCheckinTargets.GetCheckinProgresses(),
            atKeyPath: "data"
        )
    }
}
