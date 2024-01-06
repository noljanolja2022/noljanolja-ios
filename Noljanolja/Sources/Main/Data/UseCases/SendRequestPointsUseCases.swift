//
//  SendRequestPointsUseCases.swift
//  Noljanolja
//
//  Created by duydinhv on 05/01/2024.
//

import Combine
import Foundation

// MARK: - SendRequestPointsUseCases

protocol SendRequestPointsUseCases {
    func sendPoints(_ points: Int, _ toUserId: String) -> AnyPublisher<SendRequestPointsModel, Error>
    func requestPoint(_ points: Int, _ toUserId: String) -> AnyPublisher<SendRequestPointsModel, Error>
}

// MARK: - SendRequestPointsUseCasesImpl

final class SendRequestPointsUseCasesImpl: SendRequestPointsUseCases {
    static let shared: SendRequestPointsUseCases = SendRequestPointsUseCasesImpl()

    // MARK: Dependencies

    private let sendRequestPointNetworkRepository: SendRequestPointNetworkRepository

    init(sendRequestPointNetworkRepository: SendRequestPointNetworkRepository = SendRequestPointNetworkRepositoryImpl.shared) {
        self.sendRequestPointNetworkRepository = sendRequestPointNetworkRepository
    }

    func sendPoints(_ points: Int, _ toUserId: String) -> AnyPublisher<SendRequestPointsModel, Error> {
        sendRequestPointNetworkRepository
            .sendPoints(points, toUserId)
            .compactMap { $0 }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    func requestPoint(_ points: Int, _ toUserId: String) -> AnyPublisher<SendRequestPointsModel, Error> {
        sendRequestPointNetworkRepository
            .requestPoint(points, toUserId)
            .compactMap { $0 }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}
