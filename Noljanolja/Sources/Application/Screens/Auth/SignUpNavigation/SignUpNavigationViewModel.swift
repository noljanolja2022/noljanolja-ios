//
//  SignUpNavigationViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/02/2023.
//
//

import Combine
import UIKit

// MARK: - SignUpNavigationViewModelDelegate

protocol SignUpNavigationViewModelDelegate: AnyObject {}

// MARK: - SignUpNavigationViewModelType

protocol SignUpNavigationViewModelType: ObservableObject, TermsViewModelDelegate, SignUpViewModelDelegate {
    // MARK: State

    var step: SignUpStep { get set }
}

// MARK: - SignUpNavigationViewModel

final class SignUpNavigationViewModel: SignUpNavigationViewModelType {
    // MARK: Dependencies

    weak var delegate: SignUpNavigationViewModelDelegate?

    // MARK: State

    @Published var step: SignUpStep = .first

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: SignUpNavigationViewModelDelegate? = nil) {
        self.delegate = delegate

        configure()
    }

    private func configure() {}
}

// MARK: TermsViewModelDelegate, SignUpViewModelDelegate

extension SignUpNavigationViewModel: TermsViewModelDelegate, SignUpViewModelDelegate {
    func updateSignUpStep(_ step: SignUpStep) {
        self.step = step
    }
}
