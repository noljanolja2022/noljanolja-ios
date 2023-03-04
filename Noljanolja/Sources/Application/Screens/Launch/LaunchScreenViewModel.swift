//
//  LaunchScreenViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 27/02/2023.
//
//

import Combine

// MARK: - LaunchScreenViewModelDelegate

protocol LaunchScreenViewModelDelegate: AnyObject {
    func getLaunchDataFailed()
}

// MARK: - LaunchScreenViewModelType

protocol LaunchScreenViewModelType:
    ViewModelType where State == LaunchScreenViewModel.State, Action == LaunchScreenViewModel.Action {}

extension LaunchScreenViewModel {
    struct State {
        var isContinueButtonHidden = true
        var isTermsShown = false
    }

    enum Action {
        case loadData
        case navigateToTerms
    }
}

// MARK: - LaunchScreenViewModel

final class LaunchScreenViewModel: LaunchScreenViewModelType {
    // MARK: State

    @Published var state: State

    // MARK: Dependencies

    private let authServices: AuthServicesType
    private let profileService: ProfileServiceType
    private weak var delegate: LaunchScreenViewModelDelegate?

    // MARK: Action

    private let loadDataTrigger = PassthroughSubject<Void, Never>()

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(state: State = State(),
         authServices: AuthServicesType = AuthServices.default,
         profileService: ProfileServiceType = ProfileService.default,
         delegate: LaunchScreenViewModelDelegate? = nil) {
        self.state = state
        self.authServices = authServices
        self.profileService = profileService
        self.delegate = delegate

        configure()
    }

    func send(_ action: Action) {
        switch action {
        case .loadData:
            loadDataTrigger.send()
        case .navigateToTerms:
            state.isTermsShown = true
        }
    }

    private func configure() {
        loadDataTrigger
            .flatMap { [weak self] _ -> AnyPublisher<String, Error> in
                guard let self else {
                    return Empty<String, Error>().eraseToAnyPublisher()
                }
                return self.authServices.getIDTokenResult()
            }
            .flatMap { [weak self] _ -> AnyPublisher<ProfileModel, Error> in
                guard let self else {
                    return Empty<ProfileModel, Error>().eraseToAnyPublisher()
                }
                return self.profileService.getProfile()
            }
            .eraseToResultAnyPublisher()
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success:
                    logger.error("Get pre data successful")
                case let .failure(error):
                    logger.error("Get pre data failed - \(error.localizedDescription)")
                    self?.state.isContinueButtonHidden = false
                }
            })
            .store(in: &cancellables)
    }
}
