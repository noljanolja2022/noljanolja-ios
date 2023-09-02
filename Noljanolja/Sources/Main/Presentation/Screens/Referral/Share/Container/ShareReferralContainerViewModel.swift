//
//  ShareReferralContainerViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 02/08/2023.
//
//

import Combine
import Foundation
import SwiftUIX

// MARK: - ShareReferralContainerViewModelDelegate

protocol ShareReferralContainerViewModelDelegate: AnyObject {}

// MARK: - ShareReferralContainerViewModel

final class ShareReferralContainerViewModel: ViewModel {
    // MARK: State

    // MARK: Navigations

    @Published var fullScreenCoverType: ShareReferralContainerFullScreenCoverType?

    // MARK: Action

    let closeAction = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    let code: String?
    private weak var delegate: ShareReferralContainerViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(code: String?,
         delegate: ShareReferralContainerViewModelDelegate? = nil) {
        self.code = code
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        isAppearSubject
            .first(where: { $0 })
            .sink { [weak self] _ in
                self?.fullScreenCoverType = .horizontalShare
            }
            .store(in: &cancellables)
    }
}

// MARK: HorizontalShareReferralViewModelDelegate

extension ShareReferralContainerViewModel: HorizontalShareReferralViewModelDelegate {
    func horizontalShareReferralViewModelDidTapMore() {
        fullScreenCoverType = .verticalShare
    }

    func shareReferralViewModelDidShare() {
        closeAction.send()
    }
}
