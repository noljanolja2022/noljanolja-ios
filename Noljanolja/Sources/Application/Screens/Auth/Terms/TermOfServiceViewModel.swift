//
//  TermOfServiceViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 28/02/2023.
//
//

import _SwiftUINavigationState
import Combine

// MARK: - TermOfServiceViewModelDelegate

protocol TermOfServiceViewModelDelegate: AnyObject {
    func navigateToAuth()
}

// MARK: - TermOfServiceViewModelType

protocol TermOfServiceViewModelType:
    ViewModelType where State == TermOfServiceViewModel.State, Action == TermOfServiceViewModel.Action {}

extension TermOfServiceViewModel {
    struct State {
        var termItems = TermOfServiceItemType.allCases
        var termItemCheckeds = Dictionary(uniqueKeysWithValues: TermOfServiceItemType.allCases.map { ($0, false) })
        var isAllTermChecked: Bool {
            get {
                termItemCheckeds.map { $0.value }.reduce(true) { $0 && $1 }
            }
            set {
                termItemCheckeds = Dictionary(uniqueKeysWithValues: TermOfServiceItemType.allCases.map { ($0, newValue) })
            }
        }

        var alertState: AlertState<Void>?
    }

    enum Action {
        case openHelpAlert
        case checkTermItem(itemType: TermOfServiceItemType, checked: Bool)
        case checkAllTermItems(checked: Bool)
        case tapContinueButton
    }
}

// MARK: - TermOfServiceViewModel

final class TermOfServiceViewModel: TermOfServiceViewModelType {
    // MARK: Dependencies

    private weak var delegate: TermOfServiceViewModelDelegate?

    // MARK: State

    @Published var state: State

    // MARK: Action

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(state: State = State(),
         delegate: TermOfServiceViewModelDelegate? = nil) {
        self.state = state
        self.delegate = delegate

        configure()
    }

    func send(_ action: Action) {
        switch action {
        case .openHelpAlert:
            state.alertState = AlertState(
                title: TextState(""),
                message: TextState("You may choose to agree to ther terms individually.\nYou may use ther service even if you don't agree to the optional terms and coditions"),
                dismissButton: .cancel(TextState("OK"))
            )
        case let .checkTermItem(itemType, checked):
            state.termItemCheckeds[itemType] = checked
        case let .checkAllTermItems(checked):
            state.isAllTermChecked = checked
        case .tapContinueButton:
            delegate?.navigateToAuth()
        }
    }

    private func configure() {}
}
