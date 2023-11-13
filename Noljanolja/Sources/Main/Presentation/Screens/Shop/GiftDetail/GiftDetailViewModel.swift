//
//  GiftDetailViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 13/06/2023.
//
//

import _SwiftUINavigationState
import Combine
import Foundation

// MARK: - GiftDetailViewModelDelegate

protocol GiftDetailViewModelDelegate: AnyObject {}

// MARK: - GiftDetailViewModel

final class GiftDetailViewModel: ViewModel {
    // MARK: State

    @Published var viewState = ViewState.content
    @Published var model: GiftDetailModel?
    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<GiftDetailAlertActionType>?

    // MARK: Action

    let buyGiftAction = PassthroughSubject<Void, Never>()
    let displayMyGiftAction = PassthroughSubject<MyGift, Never>()

    // MARK: Dependencies

    private let giftDetailInputTypeSubject: CurrentValueSubject<GiftDetailInputType, Never>
    private let giftsNetworkRepository: GiftsNetworkRepository
    private let coinExchangeUseCases: CoinExchangeUseCases
    private weak var delegate: GiftDetailViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(giftDetailInputType: GiftDetailInputType,
         giftsNetworkRepository: GiftsNetworkRepository = GiftsNetworkRepositoryImpl.default,
         coinExchangeUseCases: CoinExchangeUseCases = CoinExchangeUseCasesImpl.shared,
         delegate: GiftDetailViewModelDelegate? = nil) {
        self.giftDetailInputTypeSubject = CurrentValueSubject<GiftDetailInputType, Never>(giftDetailInputType)
        self.giftsNetworkRepository = giftsNetworkRepository
        self.coinExchangeUseCases = coinExchangeUseCases
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureBindData()
        configureLoadData()
        configureActions()
    }

    private func configureBindData() {
        displayMyGiftAction
            .sink { [weak self] in
                self?.giftDetailInputTypeSubject.send(.myGift($0))
            }
            .store(in: &cancellables)
    }

    private func configureLoadData() {
        isAppearSubject
            .first { $0 }
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in self?.viewState = .loading })
            .flatMapLatestToResult { [weak self] _ in
                guard let self else {
                    return Empty<GiftDetailModel, Error>().eraseToAnyPublisher()
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
    }

    private func configureActions() {
        buyGiftAction
            .withLatestFrom(giftDetailInputTypeSubject)
            .compactMap { $0.gift }
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
            .flatMapLatestToResult { [weak self] gift in
                guard let self else {
                    return Empty<MyGift, Error>().eraseToAnyPublisher()
                }
                return self.buyGift(gift.id)
            }
            .sink { [weak self] result in
                guard let self else { return }
                self.isProgressHUDShowing = false
                switch result {
                case let .success(model):
                    self.alertState = AlertState(
                        title: TextState(L10n.commonSuccess),
                        message: TextState(L10n.shopOrderGiftSuccess),
                        primaryButton: .destructive(TextState(L10n.shopLater.uppercased()), action: .send(.back)),
                        secondaryButton: .default(TextState(L10n.commonUse.uppercased()), action: .send(.viewDetail(model)))
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

extension GiftDetailViewModel {
    private func getData() -> AnyPublisher<GiftDetailModel, Error> {
        Publishers.CombineLatest(
            coinExchangeUseCases.getCoin(),
            giftDetailInputTypeSubject
                .setFailureType(to: Error.self)
        )
        .receive(on: DispatchQueue.global(qos: .background))
        .map { GiftDetailModel(coinModel: $0.0, giftDetailInputType: $0.1) }
        .eraseToAnyPublisher()
    }

    private func buyGift(_ id: String) -> AnyPublisher<MyGift, Error> {
        giftsNetworkRepository.buyGift(id)
            .flatMapLatest { [weak self] myGift in
                guard let self else {
                    return Empty<MyGift, Error>().eraseToAnyPublisher()
                }
                return self.coinExchangeUseCases.getCoin()
                    .map { _ in myGift }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
