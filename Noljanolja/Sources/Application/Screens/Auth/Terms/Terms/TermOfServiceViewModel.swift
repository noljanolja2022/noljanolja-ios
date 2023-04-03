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
            termItemCheckeds.map { $0.value }.reduce(true) { $0 && $1 }
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

//    func send(_ action: Action) {
//        switch action {
//        case .openHelpAlert:
//            state.alertState = AlertState(
//                title: TextState(""),
//                message: TextState("You may choose to agree to ther terms individually.\nYou may use ther service even if you don't agree to the optional terms and coditions"),
//                dismissButton: .cancel(TextState("OK"))
//            )
//        case let .checkTermItem(itemType, checked):
//            state.termItemCheckeds[itemType] = checked
//        case let .checkAllTermItems(checked):
//            state.isAllTermChecked = checked
//        case .tapContinueButton:
//            delegate?.navigateToAuth()
//        }
//    }

    private func configure() {
        actionSubject
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                self?.delegate?.navigateToAuth()
            })
            .store(in: &cancellables)
    }
}
