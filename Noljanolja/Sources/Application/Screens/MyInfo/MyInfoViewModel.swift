//
//  MyInfoViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/02/2023.
//
//

import Combine

// MARK: - MyInfoViewModelDelegate

protocol MyInfoViewModelDelegate: AnyObject {}

// MARK: - MyInfoViewModelType

protocol MyInfoViewModelType: ObservableObject {
    // MARK: State

    var profileModel: ProfileModel? { get set }

    // MARK: Action

    var signOutTrigger: PassthroughSubject<Void, Never> { get }
}

// MARK: - MyInfoViewModel

final class MyInfoViewModel: MyInfoViewModelType {
    // MARK: Dependencies

    private weak var delegate: MyInfoViewModelDelegate?
    private let authServices: AuthServicesType

    // MARK: State

    @Published var profileModel: ProfileModel?

    // MARK: Action

    let signOutTrigger = PassthroughSubject<Void, Never>()

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: MyInfoViewModelDelegate? = nil,
         authServices: AuthServicesType = AuthServices.default,
         profileModel: ProfileModel?) {
        self.delegate = delegate
        self.authServices = authServices
        self.profileModel = profileModel

        configure()
    }

    private func configure() {
        signOutTrigger
            .flatMap { [weak self] _ -> AnyPublisher<Result<Void, Error>, Never> in
                guard let self else { return Empty<Result<Void, Error>, Never>().eraseToAnyPublisher() }
                return self.authServices.signOut().eraseToResultAnyPublisher()
            }
            .sink(receiveValue: { result in
                switch result {
                case .success:
                    logger.info("Sign out successful")
                case .failure:
                    logger.error("Sign out failed")
                }
            })
            .store(in: &cancellables)
    }
}
