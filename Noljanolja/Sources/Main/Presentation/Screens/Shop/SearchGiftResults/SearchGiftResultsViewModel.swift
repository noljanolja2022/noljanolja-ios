//
//  SearchGiftResultsViewModel.swift
//  Noljanolja
//
//  Created by duydinhv on 21/11/2023.
//

import _SwiftUINavigationState
import Combine
import Foundation

// MARK: - SearchGiftResultsViewModelDelegate

protocol SearchGiftResultsViewModelDelegate: AnyObject {}

// MARK: - SearchGiftResultsViewModel

class SearchGiftResultsViewModel: ViewModel {
    @Published var viewState = ViewState.content
    @Published var footerState = StatefullFooterViewState.normal
    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Void>?
    @Published var model: SearchGiftsModel?

    let loadMoreAction = PassthroughSubject<Void, Never>()

    @Published private var page = 0
    private let pageSize = 20
    private var cancellables = Set<AnyCancellable>()

    @Published var navigationType: SearchGiftResultsNavigationType?

    private let coinExchangeUseCases: CoinExchangeUseCases
    private let giftsNetworkRepository: GiftsNetworkRepository

    private weak var delegate: SearchGiftResultsViewModelDelegate?

    let searchText: String

    init(searchText: String,
         coinExchangeUseCases: CoinExchangeUseCases = CoinExchangeUseCasesImpl.shared,
         giftsNetworkRepository: GiftsNetworkRepository = GiftsNetworkRepositoryImpl.default,
         delegate: SearchGiftResultsViewModelDelegate? = nil) {
        self.searchText = searchText
        self.coinExchangeUseCases = coinExchangeUseCases
        self.giftsNetworkRepository = giftsNetworkRepository
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureLoadData()
    }

    private func configureLoadData() {
        isAppearSubject
            .filter { $0 }
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.viewState = .loading
                self?.footerState = .loading
            })
            .flatMapLatestToResult { [weak self] _ -> AnyPublisher<SearchGiftsModel, Error> in
                guard let self else {
                    return Empty<SearchGiftsModel, Error>().eraseToAnyPublisher()
                }
                return self.getData()
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(model):
                    self.model = model
                    self.page = model.giftsResponse.pagination.page
                    self.viewState = .content
                    self.footerState = model.giftsResponse.pagination.total == self.page ? .noMoreData : .normal
                case .failure:
                    self.viewState = .error
                    self.footerState = .error
                }
            })
            .store(in: &cancellables)

        loadMoreAction
            .filter { [weak self] in self?.footerState.isLoadEnabled ?? false }
            .withLatestFrom($page)
            .map { currentPage -> Int in currentPage + 1 }
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.viewState = .loading
                self?.footerState = .loading
            })
            .flatMapLatestToResult { [weak self] page -> AnyPublisher<PaginationResponse<[Gift]>, Error> in
                guard let self else {
                    return Empty<PaginationResponse<[Gift]>, Error>().eraseToAnyPublisher()
                }
                return self.giftsNetworkRepository
                    .getGiftsInShop(query: self.searchText, page: page, pageSize: self.pageSize)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(response):
                    if response.pagination.page == NetworkConfigs.Param.firstPage {
                        self.model = SearchGiftsModel(
                            coinModel: self.model?.coinModel,
                            giftsResponse: response
                        )
                    } else {
                        let data = self.model?.giftsResponse.data ?? [] + response.data
                        self.model = SearchGiftsModel(
                            coinModel: self.model?.coinModel,
                            giftsResponse: PaginationResponse<[Gift]>(data: data, pagination: response.pagination)
                        )
                    }
                    self.page = response.pagination.page
                    self.viewState = .content
                    self.footerState = response.pagination.total == self.page ? .noMoreData : .normal
                case .failure:
                    self.viewState = .error
                    self.footerState = .error
                }
            })
            .store(in: &cancellables)
    }
}

extension SearchGiftResultsViewModel {
    private func getData() -> AnyPublisher<SearchGiftsModel, Error> {
        Publishers.CombineLatest(
            coinExchangeUseCases
                .getCoin(),
            giftsNetworkRepository.getGiftsInShop(query: searchText, page: NetworkConfigs.Param.firstPage, pageSize: pageSize)
        )
        .map {
            SearchGiftsModel(coinModel: $0.0, giftsResponse: $0.1)
        }
        .eraseToAnyPublisher()
    }
}
