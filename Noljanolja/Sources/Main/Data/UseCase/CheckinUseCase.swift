//
//  CheckinUseCase.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 31/07/2023.
//

import Combine
import CombineExt
import Foundation

// MARK: - CheckinUseCase

protocol CheckinUseCase {
    func getCheckinProgresses() -> AnyPublisher<[CheckinProgress], Error>
    func dailyCheckin() -> AnyPublisher<String, Error>
}

// MARK: - CheckinUseCaseImpl

final class CheckinUseCaseImpl: CheckinUseCase {
    static let shared = CheckinUseCaseImpl()

    private let localCheckinRepository: LocalCheckingRepository
    private let networkCheckinRepository: CheckinRepository

    init(localCheckinRepository: LocalCheckingRepository = LocalCheckingRepositoryImpl.shared,
         networkCheckinRepository: CheckinRepository = CheckinRepositoryImpl.shared) {
        self.localCheckinRepository = localCheckinRepository
        self.networkCheckinRepository = networkCheckinRepository
    }

    func getCheckinProgresses() -> AnyPublisher<[CheckinProgress], Error> {
        localCheckinRepository
            .getCheckinProgresses()
            .setFailureType(to: Error.self)
            .flatMapLatest { [weak self] checkinProgresses -> AnyPublisher<[CheckinProgress], Error> in
                guard let self else {
                    return Fail(error: CommonError.captureSelfNotFound).eraseToAnyPublisher()
                }
                if let checkinProgresses, !checkinProgresses.isEmpty {
                    return Just(checkinProgresses)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                } else {
                    return self.networkCheckinRepository
                        .getCheckinProgresses()
                        .handleEvents(receiveOutput: { [weak self] in
                            self?.localCheckinRepository.updateCheckinProgresses($0)
                        })
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }

    func dailyCheckin() -> AnyPublisher<String, Error> {
        networkCheckinRepository
            .dailyCheckin()
            .flatMapLatest { [weak self] message -> AnyPublisher<String, Error> in
                guard let self else {
                    return Fail(error: CommonError.captureSelfNotFound).eraseToAnyPublisher()
                }
                return self.networkCheckinRepository
                    .getCheckinProgresses()
                    .handleEvents(receiveOutput: { [weak self] in
                        self?.localCheckinRepository.updateCheckinProgresses($0)
                    })
                    .map { _ in message }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
