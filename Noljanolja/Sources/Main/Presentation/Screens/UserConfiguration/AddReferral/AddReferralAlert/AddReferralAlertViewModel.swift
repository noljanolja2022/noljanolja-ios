//
//  AddReferralAlertViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/08/2023.
//
//

import Combine
import Foundation

// MARK: - AddReferralAlertViewModelDelegate

protocol AddReferralAlertViewModelDelegate: AnyObject {
    func addReferralAlertViewModelDidComplete()
}

// MARK: - AddReferralAlertViewModel

final class AddReferralAlertViewModel: ViewModel {
    // MARK: State

    // MARK: Action

    let action = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    let rewardPoints: Int
    private weak var delegate: AddReferralAlertViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(rewardPoints: Int,
         delegate: AddReferralAlertViewModelDelegate? = nil) {
        self.rewardPoints = rewardPoints
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        action
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                self?.delegate?.addReferralAlertViewModelDidComplete()
            })
            .store(in: &cancellables)
    }
}
