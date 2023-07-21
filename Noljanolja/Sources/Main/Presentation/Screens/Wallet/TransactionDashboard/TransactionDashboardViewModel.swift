//
//  TransactionDashboardViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 19/05/2023.
//
//

import Combine
import Foundation

// MARK: - TransactionDashboardViewModelDelegate

protocol TransactionDashboardViewModelDelegate: AnyObject {}

// MARK: - TransactionDashboardViewModel

final class TransactionDashboardViewModel: ViewModel {
    // MARK: State

    @Published var viewState = ViewState.loading
    @Published var model: TransactionDashboardModel?

    // MARK: Action

    // MARK: Dependencies

    private let monthYearDate: Date
    private let loyaltyAPI: LoyaltyAPIType
    private weak var delegate: TransactionDashboardViewModelDelegate?

    // MARK: Private

    private let transationsSubject = CurrentValueSubject<[Transaction], Never>([])
    private var cancellables = Set<AnyCancellable>()

    init(monthYearDate: Date,
         loyaltyAPI: LoyaltyAPIType = LoyaltyAPI.default,
         delegate: TransactionDashboardViewModelDelegate? = nil) {
        self.monthYearDate = monthYearDate
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
        let monthYearDate = monthYearDate

        transationsSubject
            .map { TransactionDashboardBuilder(monthYearDate: monthYearDate, models: $0).buildModel() }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.model = $0 }
            .store(in: &cancellables)
    }

    private func configureLoadData() {
        let monthYearDate = monthYearDate

        isAppearSubject
            .first(where: { $0 })
            .handleEvents(receiveOutput: { [weak self] _ in self?.viewState = .loading })
            .flatMapLatestToResult { [weak self] _ -> AnyPublisher<[Transaction], Error> in
                guard let self else {
                    return Empty<[Transaction], Error>().eraseToAnyPublisher()
                }
                return self.loyaltyAPI.getTransactionHistory(
                    monthYearDate: monthYearDate
                )
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case let .success(model):
                    self?.transationsSubject.send(model)
                    self?.viewState = .content
                case .failure:
                    self?.viewState = .error
                }
            })
            .store(in: &cancellables)
    }
}
