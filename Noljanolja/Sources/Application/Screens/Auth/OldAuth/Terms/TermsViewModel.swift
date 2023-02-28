//
//  TermsViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 15/02/2023.
//
//

import Combine

// MARK: - TermsViewModelDelegate

protocol TermsViewModelDelegate: AnyObject {
    func updateSignUpStep(_ step: SignUpStep)
    func selectTermItemType(_ item: TermItemType)
    func closeAuthFlow()
}

// MARK: - TermsViewModelType

protocol TermsViewModelType: ObservableObject, SignUpViewModelDelegate {
    // MARK: State

    var isAllTermAgreed: Bool { get set }
    var termItemTypes: [TermItemType: Bool] { get set }

    var selectedTermItemType: TermItemType? { get set }

    var isShowingSignUpView: Bool { get set }

    // MARK: Action

    var updateSignUpStepTrigger: PassthroughSubject<SignUpStep, Never> { get }
}

// MARK: - TermsViewModel

final class TermsViewModel: TermsViewModelType {
    // MARK: Dependencies

    private weak var delegate: TermsViewModelDelegate?

    // MARK: State

    @Published var isAllTermAgreed = false
    @Published var termItemTypes = Dictionary(uniqueKeysWithValues: TermItemType.allCases.map { ($0, false) })

    @Published var selectedTermItemType: TermItemType?

    @Published var isShowingSignUpView = false

    // MARK: Action

    let updateSignUpStepTrigger = PassthroughSubject<SignUpStep, Never>()

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: TermsViewModelDelegate? = nil) {
        self.delegate = delegate

        configure()
    }

    private func configure() {
        updateSignUpStepTrigger
            .sink(receiveValue: { [weak self] in self?.delegate?.updateSignUpStep($0) })
            .store(in: &cancellables)

        $selectedTermItemType
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] in self?.delegate?.selectTermItemType($0) })
            .store(in: &cancellables)
    }
}

// MARK: SignUpViewModelDelegate

extension TermsViewModel: SignUpViewModelDelegate {
    func updateSignUpStep(_ step: SignUpStep) {
        delegate?.updateSignUpStep(step)
    }

    func closeAuthFlow() {
        delegate?.closeAuthFlow()
    }
}
