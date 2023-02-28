//
//  TermOfServiceViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 28/02/2023.
//
//

import Combine

// MARK: - TermOfServiceViewModelDelegate

protocol TermOfServiceViewModelDelegate: AnyObject {}

// MARK: - TermOfServiceViewModelType

protocol TermOfServiceViewModelType: ObservableObject {
    // MARK: State

    var isShowHelpAlert: Bool { get set }

    var isAllTermAgreed: Bool { get set }
    var termItemTypes: [TermOfServiceItemType: Bool] { get set }

    var isShowingAuthView: Bool { get set }

    // MARK: Action
}

// MARK: - TermOfServiceViewModel

final class TermOfServiceViewModel: TermOfServiceViewModelType {
    // MARK: Dependencies

    private weak var delegate: TermOfServiceViewModelDelegate?

    // MARK: State

    @Published var isShowHelpAlert = false

    @Published var isAllTermAgreed = false
    @Published var termItemTypes = Dictionary(uniqueKeysWithValues: TermOfServiceItemType.allCases.map { ($0, false) })

    @Published var isShowingAuthView = false

    // MARK: Action

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: TermOfServiceViewModelDelegate? = nil) {
        self.delegate = delegate

        configure()
    }

    private func configure() {}
}
