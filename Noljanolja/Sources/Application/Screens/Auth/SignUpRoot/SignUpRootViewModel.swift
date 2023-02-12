//
//  SignUpRootViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/02/2023.
//
//

import Combine

final class SignUpRootViewModel: ObservableObject {
    // MARK: Dependencies

    // MARK: Input

    // MARK: Output

    @Published var step: SignUpStep = .first

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init() {
        configure()
    }

    private func configure() {}
}
