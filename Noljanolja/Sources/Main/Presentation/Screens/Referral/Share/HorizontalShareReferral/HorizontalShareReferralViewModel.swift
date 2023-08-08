//
//  HorizontalShareReferralViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 05/08/2023.
//
//

import Combine
import Foundation

// MARK: - HorizontalShareReferralViewModelDelegate

protocol HorizontalShareReferralViewModelDelegate: ShareReferralViewModelDelegate {
    func didTapMore()
}

// MARK: - HorizontalShareReferralViewModel

final class HorizontalShareReferralViewModel: ShareReferralViewModel {
    // MARK: Action

    let moreAction = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    private weak var delegate: HorizontalShareReferralViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(code: String?,
         delegate: HorizontalShareReferralViewModelDelegate? = nil) {
        self.delegate = delegate
        super.init(code: code, delegate: delegate)

        configure()
    }

    private func configure() {
        configureActions()
    }

    private func configureActions() {
        moreAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.delegate?.didTapMore()
            }
            .store(in: &cancellables)
    }
}
