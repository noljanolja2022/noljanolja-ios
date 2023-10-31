//
//  NetworkDataNetworkRepository.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 18/07/2023.
//

import Combine
import Foundation
import Moya

// MARK: - DataTargets

private enum DataTargets {
    struct GetData: BaseAuthTargetType {
        var baseURL: URL {
            url
        }

        let path = ""
        let method: Moya.Method = .get
        var task: Task { .requestPlain }

        let url: URL
    }
}

// MARK: - DataNetworkRepository

protocol DataNetworkRepository {
    func getData(url: URL) -> AnyPublisher<Data, Error>
}

// MARK: - DataNetworkRepositoryImpl

final class DataNetworkRepositoryImpl: DataNetworkRepository {
    static let shared = DataNetworkRepositoryImpl()

    private let api: ApiType

    init(api: ApiType = Api.default) {
        self.api = api
    }

    func getData(url: URL) -> AnyPublisher<Data, Error> {
        api
            .request(target: DataTargets.GetData(url: url))
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
