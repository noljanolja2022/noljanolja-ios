//
//  MyPageViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/02/2023.
//
//

import Combine
import Foundation
import UIKit

// MARK: - MyPageViewModelDelegate

protocol MyPageViewModelDelegate: AnyObject {}

// MARK: - MyPageViewModelType

protocol MyPageViewModelType: ObservableObject {
    // MARK: State

    // MARK: Action

    var customerServiceCenterTrigger: PassthroughSubject<Void, Never> { get }
}

// MARK: - MyPageViewModel

final class MyPageViewModel: MyPageViewModelType {
    // MARK: Dependencies

    private weak var delegate: MyPageViewModelDelegate?

    // MARK: State

    // MARK: Action

    let customerServiceCenterTrigger = PassthroughSubject<Void, Never>()

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: MyPageViewModelDelegate? = nil) {
        self.delegate = delegate

        configure()
    }

    private func configure() {
        customerServiceCenterTrigger
            .sink(receiveValue: {
                if let url = URL(string: "tel://\(AppConfigs.App.customerServiceCenter)"),
                   UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            })
            .store(in: &cancellables)
    }
}
