//
//  TransactionHistoryViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 16/05/2023.
//
//

import Combine
import Foundation

// MARK: - TransactionHistoryViewModelDelegate

protocol TransactionHistoryViewModelDelegate: AnyObject {}

// MARK: - TransactionHistoryViewModel

final class TransactionHistoryViewModel: ViewModel {
    // MARK: State

    @Published var selectedTransactionType = TransactionFilterType.all

    @Published var viewState = ViewState.loading
    @Published var footerState = StatefullFooterViewState.normal
    @Published var model: TransactionHistoryModel?

    // MARK: Navigations

    @Published var navigationType: TransactionHistoryNavigationType?

    // MARK: Action

    let loadMoreAction = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    private let loyaltyAPI: LoyaltyAPIType
    private weak var delegate: TransactionHistoryViewModelDelegate?

    // MARK: Private

    private let lastOffsetDateSubject = CurrentValueSubject<Date?, Never>(nil)
    private let transationsSubject = CurrentValueSubject<[Transaction], Never>([])
    var cancellables = Set<AnyCancellable>()

    init(loyaltyAPI: LoyaltyAPIType = LoyaltyAPI.default,
         delegate: TransactionHistoryViewModelDelegate? = nil) {
        self.loyaltyAPI = loyaltyAPI
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureBindData()
        configureLoadData()
    }

    private func configureBindData() {
        transationsSubject
            .map {
                TransactionHistoryModelBuilder(models: $0).build()
            }
            .sink(receiveValue: { [weak self] in
                self?.model = $0
            })
            .store(in: &cancellables)
    }

    private func configureLoadData() {
        let loadDataAction = Publishers.Merge3(
            isAppearSubject
                .first(where: { $0 })
                .mapToVoid(),
            $selectedTransactionType
                .dropFirst()
                .handleEvents(receiveOutput: { [weak self] _ in
                    self?.transationsSubject.send([])
                })
                .mapToVoid(),
            loadMoreAction
                .filter { [weak self] in self?.footerState.isLoadEnabled ?? false }
                .mapToVoid()
        )
        .withLatestFrom(Publishers.CombineLatest($selectedTransactionType, lastOffsetDateSubject))

        loadDataAction
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.viewState = .loading
                self?.footerState = .loading
            })
            .flatMapLatestToResult { [weak self] transactionType, lastOffsetDate -> AnyPublisher<[Transaction], Error> in
                guard let self else {
                    return Empty<[Transaction], Error>().eraseToAnyPublisher()
                }
                return self.loyaltyAPI.getTransactionHistory(
                    filterType: transactionType,
                    lastOffsetDate: lastOffsetDate
                )
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case let .success(model):
                    let newTransactions = (self?.transationsSubject.value ?? []) + model
                    self?.transationsSubject.send(newTransactions)
                    self?.viewState = .content
                    self?.footerState = model.isEmpty ? .noMoreData : .normal
                case .failure:
                    self?.viewState = .error
                    self?.footerState = .error
                }
            })
            .store(in: &cancellables)
    }
}
