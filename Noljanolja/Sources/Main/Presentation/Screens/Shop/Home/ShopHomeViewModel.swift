//
//  ShopHomeViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 13/06/2023.
//
//

import _SwiftUINavigationState
import Combine
import Foundation

// MARK: - ShopHomeViewModelDelegate

protocol ShopHomeViewModelDelegate: AnyObject {
    func shopHomeViewModelSignOut()
}

// MARK: - ShopHomeViewModel

final class ShopHomeViewModel: ViewModel {
    // MARK: State

    @Published var viewState = ViewState.loading
    @Published var model = ShopHomeModel()
    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Void>?
    @Published var avatarURL: String?

    // MARK: Navigations

    @Published var navigationType: ShopHomeNavigationType?

    // MARK: Action

    // MARK: Dependencies

    private let userUseCases: UserUseCases
    private let coinExchangeUseCases: CoinExchangeUseCases
    private weak var delegate: ShopHomeViewModelDelegate?

    // MARK: Private
    
    private let pageSize = 10
    private var cancellables = Set<AnyCancellable>()

    init(coinExchangeUseCases: CoinExchangeUseCases = CoinExchangeUseCasesImpl.shared,
         userUseCases: UserUseCases = UserUseCasesImpl.default,
         delegate: ShopHomeViewModelDelegate? = nil) {
        self.userUseCases = userUseCases
        self.coinExchangeUseCases = coinExchangeUseCases
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureBindData()
        configureLoadData()
    }

    private func configureBindData() {}

    private func configureLoadData() {
        isAppearSubject
            .filter { $0 }
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in self?.viewState = .loading })
            .flatMapLatestToResult { [weak self] _ in
                guard let self else {
                    return Empty<ShopHomeModel, Error>().eraseToAnyPublisher()
                }
                return self.getData()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(model):
                    self.model = model
                    self.viewState = .content
                case .failure:
                    self.viewState = .error
                }
            }
            .store(in: &cancellables)
        
        userUseCases
            .getCurrentUserPublisher()
            .sink(receiveValue: { [weak self] in
                self?.avatarURL = $0.avatar
            })
            .store(in: &cancellables)
    }
}

extension ShopHomeViewModel {
    private func getData() -> AnyPublisher<ShopHomeModel, Error> {
        coinExchangeUseCases
            .getCoin()
            .map(ShopHomeModel.init)
            .eraseToAnyPublisher()
    }
}

// MARK: ProfileSettingViewModelDelegate

extension ShopHomeViewModel: ProfileSettingViewModelDelegate {
    func profileSettingViewModelSignOut() {
        delegate?.shopHomeViewModelSignOut()
    }
}
