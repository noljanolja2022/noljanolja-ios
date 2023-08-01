//
//  LocalCheckingRepository.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 31/07/2023.
//

import Combine
import Foundation

// MARK: - LocalCheckingRepository

protocol LocalCheckingRepository {
    func getCheckinProgresses() -> CurrentValueSubject<[CheckinProgress]?, Never>
    func updateCheckinProgresses(_ checkinProgresses: [CheckinProgress])
}

// MARK: - LocalCheckingRepositoryImpl

final class LocalCheckingRepositoryImpl: LocalCheckingRepository {
    static let shared = LocalCheckingRepositoryImpl()

    private let checkinProgressesSubject = CurrentValueSubject<[CheckinProgress]?, Never>(nil)

    func getCheckinProgresses() -> CurrentValueSubject<[CheckinProgress]?, Never> {
        checkinProgressesSubject
    }

    func updateCheckinProgresses(_ checkinProgresses: [CheckinProgress]) {
        checkinProgressesSubject.send(checkinProgresses)
    }
}
