//
//  CheckingLocalRepository.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 31/07/2023.
//

import Combine
import Foundation

// MARK: - CheckingLocalRepository

protocol CheckingLocalRepository {
    func getCheckinProgresses() -> CurrentValueSubject<[CheckinProgress]?, Never>
    func updateCheckinProgresses(_ checkinProgresses: [CheckinProgress])
}

// MARK: - CheckingLocalRepositoryImpl

final class CheckingLocalRepositoryImpl: CheckingLocalRepository {
    static let shared = CheckingLocalRepositoryImpl()

    private let checkinProgressesSubject = CurrentValueSubject<[CheckinProgress]?, Never>(nil)

    func getCheckinProgresses() -> CurrentValueSubject<[CheckinProgress]?, Never> {
        checkinProgressesSubject
    }

    func updateCheckinProgresses(_ checkinProgresses: [CheckinProgress]) {
        checkinProgressesSubject.send(checkinProgresses)
    }
}
