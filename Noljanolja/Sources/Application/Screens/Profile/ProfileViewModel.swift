//
//  ProfileViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/02/2023.
//
//

import Combine

final class ProfileViewModel: ObservableObject {
    // MARK: Dependencies

    private let authServices: AuthServicesType
    private let authStore: AuthStoreType

    // MARK: Input

    let signOutTrigger = PassthroughSubject<Void, Never>()

    // MARK: Output

    @Published private(set) var token = ""

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(authServices: AuthServicesType = AuthServices.default,
         authStore: AuthStoreType = AuthStore.default) {
        self.authServices = authServices
        self.authStore = authStore

        configure()
    }

    private func configure() {
        token = authStore.getToken() ?? ""
        
        signOutTrigger
            .flatMap { [weak self] _ -> AnyPublisher<Result<Void, Error>, Never> in
                guard let self else { return Empty<Result<Void, Error>, Never>().eraseToAnyPublisher() }
                return self.authServices
                    .signOut()
                    .eraseToResultAnyPublisher()
            }
            .sink(receiveValue: { result in
                switch result {
                case .success:
                    logger.info("Signed out")
                case let .failure(error):
                    logger.error("Sign out failed: \(error.localizedDescription)")
                }
            }
            )
            .store(in: &cancellables)
    }
}
