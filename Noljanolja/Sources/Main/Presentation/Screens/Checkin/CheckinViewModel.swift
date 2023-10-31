//
//  CheckinViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 31/07/2023.
//
//

import _SwiftUINavigationState
import Combine
import Foundation

// MARK: - CheckinViewModelDelegate

protocol CheckinViewModelDelegate: AnyObject {}

// MARK: - CheckinViewModel

final class CheckinViewModel: ViewModel {
    // MARK: State

    @Published var viewState = ViewState.loading
    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Void>?
    @Published var model: CheckinModel?

    // MARK: Navigations

    @Published var navigationType: CheckinNavigationType?

    // MARK: Action

    let action = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    private let checkinUseCases: CheckinUseCases
    private weak var delegate: CheckinViewModelDelegate?

    // MARK: Private

    private let checkinProgressesSubject = CurrentValueSubject<[CheckinProgress], Never>([])
    private var cancellables = Set<AnyCancellable>()

    init(checkinUseCases: CheckinUseCases = CheckinUseCasesImpl.shared,
         delegate: CheckinViewModelDelegate? = nil) {
        self.checkinUseCases = checkinUseCases
        self.delegate = delegate
        super.init()

        configure()
    }
    
    private func configure() {
        configureBindData()
        configureActions()
        configureLoadData()
    }

    private func configureBindData() {
        checkinProgressesSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.model = CheckinModel(checkinProgresses: $0)
            }
            .store(in: &cancellables)
    }

    private func configureLoadData() {
        isAppearSubject
            .first(where: { $0 })
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in self?.viewState = .loading })
            .flatMapLatestToResult { [weak self] _ -> AnyPublisher<[CheckinProgress], Error> in
                guard let self else {
                    return Empty<[CheckinProgress], Error>().eraseToAnyPublisher()
                }
                return self.checkinUseCases.getCheckinProgresses()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(models):
                    self.checkinProgressesSubject.send(models)
                    self.viewState = .content
                case .failure:
                    self.viewState = .error
                }
            }
            .store(in: &cancellables)
    }

    private func configureActions() {
        action
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] in
                self?.isProgressHUDShowing = true
            })
            .flatMapLatestToResult { [weak self] in
                guard let self else {
                    return Fail<String, Error>(error: CommonError.captureSelfNotFound)
                        .eraseToAnyPublisher()
                }
                return self.checkinUseCases
                    .dailyCheckin()
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                self.isProgressHUDShowing = false
                switch result {
                case let .success(model):
                    self.alertState = AlertState(
                        title: TextState(L10n.commonSuccess),
                        message: TextState(model),
                        dismissButton: .cancel(TextState(L10n.commonOk.uppercased()))
                    )
                case .failure:
                    self.alertState = AlertState(
                        title: TextState(L10n.commonErrorTitle),
                        message: TextState(L10n.commonErrorDescription),
                        dismissButton: .cancel(TextState("OK"))
                    )
                }
            }
            .store(in: &cancellables)
    }
}
