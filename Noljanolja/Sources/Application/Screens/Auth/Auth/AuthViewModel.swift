//
//  AuthViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 07/02/2023.
//

import Combine

// MARK: - AuthViewModel

final class AuthViewModel: ObservableObject {
    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init() {
        configure()
    }

    private func configure() {}
}
