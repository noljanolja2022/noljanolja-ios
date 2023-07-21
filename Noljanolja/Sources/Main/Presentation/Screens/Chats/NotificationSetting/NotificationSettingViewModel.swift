//
//  NotificationSettingViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 11/05/2023.
//
//

import Combine
import Foundation

// MARK: - NotificationSettingViewModelDelegate

protocol NotificationSettingViewModelDelegate: AnyObject {}

// MARK: - NotificationSettingViewModel

final class NotificationSettingViewModel: ViewModel {
    // MARK: State

    // MARK: Action

    // MARK: Dependencies

    private weak var delegate: NotificationSettingViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: NotificationSettingViewModelDelegate? = nil) {
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {}
}
