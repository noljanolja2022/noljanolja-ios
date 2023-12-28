//
//  TransactionDetailViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 19/05/2023.
//
//

import Combine
import Foundation

// MARK: - TransactionDetailViewModelDelegate

protocol TransactionDetailViewModelDelegate: AnyObject {}

// MARK: - TransactionDetailViewModel

final class TransactionDetailViewModel: ViewModel {
    // MARK: State

    @Published var model: TransactionDetailModel?
    @Published var viewState = ViewState.loading
    
    var transactionId: Int
    var reason: String

    // MARK: Action

    // MARK: Dependencies

    private weak var delegate: TransactionDetailViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()
    private let loyaltyNetworkRepository: LoyaltyNetworkNetworkRepository

    init(id: Int,
         reason: String,
         delegate: TransactionDetailViewModelDelegate? = nil,
         loyaltyNetworkRepository: LoyaltyNetworkNetworkRepository = LoyaltyNetworkNetworkRepository.default) {
        self.loyaltyNetworkRepository = loyaltyNetworkRepository
        self.delegate = delegate
        self.transactionId = id
        self.reason = reason
        super.init()

        configure()
    }

    private func configure() {
        isAppearSubject
            .receive(on: DispatchQueue.main)
            .first()
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.viewState = .loading
            })
            .flatMapLatestToResult { [weak self] _ -> AnyPublisher<Transaction, Error> in
                guard let self else {
                    return Empty<Transaction, Error>().eraseToAnyPublisher()
                }
                return self.loyaltyNetworkRepository.getTransactionDetail(id: self.transactionId, reason: self.reason)
            }
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case let .success(transaction):
                    self.model = TransactionDetailModel(model: transaction)
                case .failure:
                    self.viewState = .error
                }
            }
            .store(in: &cancellables)
    }
}
