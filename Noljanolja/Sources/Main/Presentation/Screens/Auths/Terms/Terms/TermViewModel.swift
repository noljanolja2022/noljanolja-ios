//
//  TermViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 28/02/2023.
//
//

import _SwiftUINavigationState
import Combine
import Foundation

// MARK: - TermViewModelDelegate

protocol TermViewModelDelegate: AnyObject {
    func termViewModelDidComplete()
}

// MARK: - TermViewModel

final class TermViewModel: ViewModel {
    // MARK: Dependencies

    private weak var delegate: TermViewModelDelegate?

    // MARK: State

    @Published var termModels = [
        TermModel(section: .compulsory, items: [.minAge, .termOfService, .personalInfo])
    ]
    @Published var termItemCheckeds = Set<TermItemType>()
    var isAllTermChecked: Bool {
        get {
            termModels
                .filter { $0.section == .compulsory }
                .map { $0.items }
                .flatMap { $0 }
                .reduce(true) {
                    $0 && termItemCheckeds.contains($1)
                }
        }
        set {
            termItemCheckeds = Set(termModels.map { $0.items }.flatMap { $0 })
        }
    }

    @Published var alertState: AlertState<Void>?

    // MARK: Action

    let actionSubject = PassthroughSubject<Void, Never>()

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: TermViewModelDelegate? = nil) {
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        actionSubject
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                self?.delegate?.termViewModelDidComplete()
            })
            .store(in: &cancellables)
    }
}
