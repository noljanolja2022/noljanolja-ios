//
//  CheckinRepository.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 31/07/2023.
//

import Combine
import Foundation
import Moya

// MARK: - CheckinTargets

private enum CheckinTargets {
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

// MARK: - CheckinNetworkRepository

protocol CheckinNetworkRepository {
    func dailyCheckin() -> AnyPublisher<String, Error>
    func getCheckinProgresses() -> AnyPublisher<[CheckinProgress], Error>
}

// MARK: - CheckinNetworkRepositoryImpl

final class CheckinNetworkRepositoryImpl: CheckinNetworkRepository {
    static let shared = CheckinNetworkRepositoryImpl()

    private let api: ApiType

    init(api: ApiType = Api.default) {
        self.api = api
    }

    func dailyCheckin() -> AnyPublisher<String, Error> {
        api.request(
            target: CheckinTargets.DailyCheckin(),
            atKeyPath: "message"
        )
    }

    func getCheckinProgresses() -> AnyPublisher<[CheckinProgress], Error> {
        api.request(
            target: CheckinTargets.GetCheckinProgresses(),
            atKeyPath: "data"
        )
    }
}
