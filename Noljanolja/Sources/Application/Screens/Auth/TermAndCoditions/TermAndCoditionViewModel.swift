//
//  TermAndConditionViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/02/2023.
//
//

import Combine
import SwiftUI

final class TermAndConditionViewModel: ObservableObject {
    // MARK: Dependencies

    // MARK: Input

    // MARK: Output

    @Binding var signUpStep: SignUpStep
    @Published var allTermAgreed = false
    @Published var termItemTypes = Dictionary(uniqueKeysWithValues: TermAndCoditionItemType.allCases.map { ($0, false) })

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(signUpStep: Binding<SignUpStep>) {
        self._signUpStep = signUpStep

        configure()
    }

    private func configure() {}
}
