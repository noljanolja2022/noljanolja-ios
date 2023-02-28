//
//  LaunchScreenViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 27/02/2023.
//
//

import Combine

// MARK: - LaunchScreenViewModelDelegate

protocol LaunchScreenViewModelDelegate: AnyObject {}

// MARK: - LaunchScreenViewModelType

protocol LaunchScreenViewModelType: ObservableObject {
    // MARK: State

    var contentTypePublisher: AnyPublisher<RootViewState.ContentType, Never> { get }
    var isContinueHidden: Bool { get set }
    var isShowingTerm: Bool { get set }

    // MARK: Action

    var loadDataTrigger: PassthroughSubject<Void, Never> { get }
}

// MARK: - LaunchScreenViewModel

final class LaunchScreenViewModel: LaunchScreenViewModelType {
    // MARK: Dependencies

    private weak var delegate: LaunchScreenViewModelDelegate?
    private let authServices: AuthServicesType
    private let profileService: ProfileServiceType

    // MARK: State

    private let contentTypeSubject = PassthroughSubject<RootViewState.ContentType, Never>()
    var contentTypePublisher: AnyPublisher<RootViewState.ContentType, Never> { contentTypeSubject.eraseToAnyPublisher() }

    @Published var isContinueHidden = true
    @Published var isShowingTerm = false

    // MARK: Action

    let loadDataTrigger = PassthroughSubject<Void, Never>()

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: LaunchScreenViewModelDelegate? = nil,
         authServices: AuthServicesType = AuthServices.default,
         profileService: ProfileServiceType = ProfileService.default) {
        self.delegate = delegate
        self.authServices = authServices
        self.profileService = profileService

        configure()
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
                    self?.contentTypeSubject.send(.main)
                    logger.error("Get pre data successful")
                case let .failure(error):
                    self?.isContinueHidden = false
                    logger.error("Get pre data failed - \(error.localizedDescription)")
                }
            })
            .store(in: &cancellables)
    }
}
