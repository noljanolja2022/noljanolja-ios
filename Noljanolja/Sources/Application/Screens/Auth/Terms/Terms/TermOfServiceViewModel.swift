//
//  TermOfServiceViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 28/02/2023.
//
//

import _SwiftUINavigationState
import Combine
import Foundation

// MARK: - TermOfServiceViewModelDelegate

protocol TermOfServiceViewModelDelegate: AnyObject {
    func navigateToAuth()
}

// MARK: - TermOfServiceViewModel

final class TermOfServiceViewModel: ViewModel {
    // MARK: Dependencies

    private weak var delegate: TermOfServiceViewModelDelegate?

    // MARK: State

    @Published var termItems = TermOfServiceItemType.allCases
    @Published var termItemCheckeds = Dictionary(uniqueKeysWithValues: TermOfServiceItemType.allCases.map { ($0, false) })
    var isAllTermChecked: Bool {
        get {
            termItemCheckeds
                .filter { $0.key.sectionType == .compulsory }
                .map { $0.value }
                .reduce(true) { $0 && $1 }
        }
        set {
            termItemCheckeds = Dictionary(uniqueKeysWithValues: TermOfServiceItemType.allCases.map { ($0, newValue) })
        }
    }

    @Published var alertState: AlertState<Void>?

    // MARK: Action

    let actionSubject = PassthroughSubject<Void, Never>()

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: TermOfServiceViewModelDelegate? = nil) {
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        actionSubject
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                self?.delegate?.navigateToAuth()
            })
            .store(in: &cancellables)
    }
}
