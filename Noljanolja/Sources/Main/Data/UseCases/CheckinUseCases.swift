//
//  CheckinUseCases.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 31/07/2023.
//

import Combine
import CombineExt
import Foundation

// MARK: - CheckinUseCases

protocol CheckinUseCases {
    func getCheckinProgresses() -> AnyPublisher<[CheckinProgress], Error>
    func dailyCheckin() -> AnyPublisher<String, Error>
}

// MARK: - CheckinUseCasesImpl

final class CheckinUseCasesImpl: CheckinUseCases {
    static let shared = CheckinUseCasesImpl()

    private let checkinLocalRepository: CheckingLocalRepository
    private let checkinNetworkRepository: CheckinNetworkRepository

    init(checkinLocalRepository: CheckingLocalRepository = CheckingLocalRepositoryImpl.shared,
         checkinNetworkRepository: CheckinNetworkRepository = CheckinNetworkRepositoryImpl.shared) {
        self.checkinLocalRepository = checkinLocalRepository
        self.checkinNetworkRepository = checkinNetworkRepository
    }

    func getCheckinProgresses() -> AnyPublisher<[CheckinProgress], Error> {
        checkinLocalRepository
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
                    return self.checkinNetworkRepository
                        .getCheckinProgresses()
                        .handleEvents(receiveOutput: { [weak self] in
                            self?.checkinLocalRepository.updateCheckinProgresses($0)
                        })
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }

    func dailyCheckin() -> AnyPublisher<String, Error> {
        checkinNetworkRepository
            .dailyCheckin()
            .flatMapLatest { [weak self] message -> AnyPublisher<String, Error> in
                guard let self else {
                    return Fail(error: CommonError.captureSelfNotFound).eraseToAnyPublisher()
                }
                return self.checkinNetworkRepository
                    .getCheckinProgresses()
                    .handleEvents(receiveOutput: { [weak self] in
                        self?.checkinLocalRepository.updateCheckinProgresses($0)
                    })
                    .map { _ in message }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
