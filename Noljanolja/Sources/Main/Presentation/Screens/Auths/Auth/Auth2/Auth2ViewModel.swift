//
//  Auth2ViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 02/10/2023.
//
//

import _SwiftUINavigationState
import Combine
import Foundation

// MARK: - Auth2ViewModelDelegate

protocol Auth2ViewModelDelegate: AnyObject {
    func googleAuthViewModelDidComplete(_ user: User)
}

// MARK: - Auth2ViewModel

final class Auth2ViewModel: ViewModel {
    // MARK: State

    @Published var remoteConfigModel = RemoteConfigModel.default
    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Bool>?

    // MARK: Action

    let googleSignInAction = PassthroughSubject<Void, Never>()
    let appleSignInAction = PassthroughSubject<Void, Never>()
    let signInWithEmailPasswordAction = PassthroughSubject<(String, String), Never>()

    // MARK: Dependencies

    private let authUseCase: AuthUseCases
    private let userUseCases: UserUseCases
    private let remoteConfigRepository: RemoteConfigRepository
    private weak var delegate: Auth2ViewModelDelegate?

    // MARK: Private

    private let getUserAction = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()

    init(authUseCase: AuthUseCases = AuthUseCasesImpl.default,
         userUseCases: UserUseCases = UserUseCasesImpl.default,
         remoteConfigRepository: RemoteConfigRepository = RemoteConfigRepositoryImpl.shared,
         delegate: Auth2ViewModelDelegate? = nil) {
        self.authUseCase = authUseCase
        self.userUseCases = userUseCases
        self.remoteConfigRepository = remoteConfigRepository
        self.delegate = delegate
        super.init()

        configure()
    }
    
    private func configure() {
        configureLoadData()
        configureAction()
    }
    
    private func configureLoadData() {
        isAppearSubject
            .first(where: { $0 })
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
            .flatMapLatestToResult { [weak self] _ in
                guard let self else {
                    return Fail<RemoteConfigModel, Error>(error: CommonError.captureSelfNotFound)
                        .eraseToAnyPublisher()
                }
                return self.remoteConfigRepository.get().eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                self.isProgressHUDShowing = false
                switch result {
                case let .success(model):
                    self.remoteConfigModel = model
                case .failure:
                    return
                }
            }
            .store(in: &cancellables)
    }

    private func configureAction() {
        signInWithEmailPasswordAction
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
            .flatMapLatestToResult { [weak self] email, password in
                guard let self else { return Fail<String, Error>(error: CommonError.captureSelfNotFound).eraseToAnyPublisher() }
                return self.authUseCase
                    .signIn(email: email, password: password)
            }
            .sink(receiveValue: { [weak self] result in
                guard let self else { return }
                self.isProgressHUDShowing = false
                switch result {
                case .success:
                    getUserAction.send()
                case .failure:
                    alertState = AlertState(
                        title: TextState(L10n.commonErrorTitle),
                        message: TextState(L10n.commonErrorDescription),
                        dismissButton: .cancel(TextState("OK"))
                    )
                }
            })
            .store(in: &cancellables)

        googleSignInAction
            .flatMapLatestToResult { [weak self] in
                guard let self else {
                    return Fail<String, Error>(error: CommonError.captureSelfNotFound)
                        .eraseToAnyPublisher()
                }
                return self.authUseCase
                    .signInWithGoogle(additionalScopes: [GIDSignInScope.youtube])
            }
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case .success:
                    getUserAction.send()
                case .failure:
                    alertState = AlertState(
                        title: TextState(L10n.commonErrorTitle),
                        message: TextState(L10n.commonErrorDescription),
                        dismissButton: .cancel(TextState("OK"))
                    )
                }
            }
            .store(in: &cancellables)
        
        appleSignInAction
            .flatMapLatestToResult { [weak self] in
                guard let self else {
                    return Fail<String, Error>(error: CommonError.captureSelfNotFound)
                        .eraseToAnyPublisher()
                }
                return self.authUseCase
                    .signInWithApple()
            }
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case .success:
                    getUserAction.send()
                case .failure:
                    alertState = AlertState(
                        title: TextState(L10n.commonErrorTitle),
                        message: TextState(L10n.commonErrorDescription),
                        dismissButton: .cancel(TextState("OK"))
                    )
                }
            }
            .store(in: &cancellables)

        getUserAction
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] in self?.isProgressHUDShowing = true })
            .flatMapLatestToResult { [weak self] in
                guard let self else {
                    return Fail<User, Error>(error: CommonError.captureSelfNotFound)
                        .eraseToAnyPublisher()
                }
                return self.userUseCases.getCurrentUser()
            }
            .sink { [weak self] result in
                guard let self else { return }
                isProgressHUDShowing = false
                switch result {
                case let .success(model):
                    delegate?.googleAuthViewModelDidComplete(model)
                case .failure:
                    alertState = AlertState(
                        title: TextState(L10n.commonErrorTitle),
                        message: TextState(L10n.commonErrorDescription),
                        dismissButton: .cancel(TextState("OK"))
                    )
                }
            }
            .store(in: &cancellables)
    }
}
