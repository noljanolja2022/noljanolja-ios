//
//  VerticalShareReferralViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 07/08/2023.
//
//

import _SwiftUINavigationState
import Combine
import Foundation

// MARK: - VerticalShareReferralViewModelDelegate

protocol VerticalShareReferralViewModelDelegate: ShareReferralViewModelDelegate {}

// MARK: - VerticalShareReferralViewModel

final class VerticalShareReferralViewModel: ShareReferralViewModel {
    // MARK: Dependencies

    private weak var delegate: VerticalShareReferralViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(code: String?,
         delegate: VerticalShareReferralViewModelDelegate? = nil) {
        self.delegate = delegate
        super.init(code: code, delegate: delegate)

        configure()
    }

    private func configure() {}
}
