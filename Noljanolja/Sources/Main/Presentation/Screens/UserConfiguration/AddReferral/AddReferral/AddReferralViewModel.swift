//
//  AddReferralViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/08/2023.
//
//

import _SwiftUINavigationState
import Combine
import Foundation

// MARK: - AddReferralViewModelDelegate

protocol AddReferralViewModelDelegate: AnyObject {
    func addReferralViewModelDidComplete()
}

// MARK: - AddReferralViewModel

final class AddReferralViewModel: ViewModel {
    // MARK: State

    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Bool>?
    @Published var referralCode = ""

    // MARK: Navigations

    @Published var fullScreenCoverType: AddReferralFullScreenCoverType?

    // MARK: Action

    let action = PassthroughSubject<Void, Never>()
    let skipAction = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    private let userAPIType: UserAPIType
    private weak var delegate: AddReferralViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(userAPIType: UserAPIType = UserAPI.default,
         delegate: AddReferralViewModelDelegate? = nil) {
        self.userAPIType = userAPIType
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        action
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] in self?.isProgressHUDShowing = true })
            .flatMapLatestToResult { [weak self] in
                guard let self else {
                    return Fail<Int, Error>(error: CommonError.captureSelfNotFound).eraseToAnyPublisher()
                }
                return self.userAPIType.addReferral(referredByCode: self.referralCode)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                self.isProgressHUDShowing = false
                switch result {
                case let .success(model):
                    self.fullScreenCoverType = .successAlert(model)
                case .failure:
                    self.alertState = AlertState(
                        title: TextState(L10n.invalidReferral),
                        message: TextState("Sorry, Please check your code again or skip this step."),
                        dismissButton: .cancel(TextState("OK"))
                    )
                }
            }
            .store(in: &cancellables)

        skipAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.delegate?.addReferralViewModelDidComplete()
            }
            .store(in: &cancellables)
    }
}

// MARK: AddReferralAlertViewModelDelegate

extension AddReferralViewModel: AddReferralAlertViewModelDelegate {
    func addReferralAlertViewModelDidComplete() {
        delegate?.addReferralViewModelDidComplete()
    }
}
