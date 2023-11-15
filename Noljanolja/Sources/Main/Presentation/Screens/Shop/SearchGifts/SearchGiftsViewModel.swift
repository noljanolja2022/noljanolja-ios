//
//  SearchGiftsViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 19/06/2023.
//
//

import _SwiftUINavigationState
import Combine
import Foundation

// MARK: - SearchGiftsViewModelDelegate

protocol SearchGiftsViewModelDelegate: AnyObject {}

// MARK: - SearchGiftsViewModel

final class SearchGiftsViewModel: ViewModel {
    // MARK: State

    @Published var viewState = ViewState.content
    @Published var footerState = StatefullFooterViewState.normal
    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Void>?
    @Published var searchText = ""
    @Published var isKeywordHidden = true
    @Published var keywords = [GiftKeyword]()
    @Published var model: SearchGiftsModel?

    // MARK: Navigations

    @Published var navigationType: SearchGiftsNavigationType?

    // MARK: Action

    let searchAction = PassthroughSubject<Void, Never>()
    let clearGiftKeywordsAction = PassthroughSubject<Void, Never>()
    let removeKeywordAction = PassthroughSubject<GiftKeyword, Never>()
    let loadMoreAction = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    private let giftKeywordLocalRepository: GiftKeywordLocalRepository
    private let coinExchangeUseCases: CoinExchangeUseCases
    private let giftsNetworkRepository: GiftsNetworkRepository
    private weak var delegate: SearchGiftsViewModelDelegate?

    // MARK: Private

    @Published private var page = 0
    private let pageSize = 20
    private var cancellables = Set<AnyCancellable>()

    init(giftKeywordLocalRepository: GiftKeywordLocalRepository = GiftKeywordLocalRepositoryImpl.shared,
         coinExchangeUseCases: CoinExchangeUseCases = CoinExchangeUseCasesImpl.shared,
         giftsNetworkRepository: GiftsNetworkRepository = GiftsNetworkRepositoryImpl.default,
         delegate: SearchGiftsViewModelDelegate? = nil) {
        self.giftKeywordLocalRepository = giftKeywordLocalRepository
        self.coinExchangeUseCases = coinExchangeUseCases
        self.giftsNetworkRepository = giftsNetworkRepository
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureLoadData()
        configureActions()
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

        let loadGiftsAction = Publishers.Merge(
            searchAction
                .withLatestFrom($searchText)
                .map { $0.trimmed }
                .filter { !$0.isEmpty }
                .removeDuplicates()
                .map { searchText -> (Int, String?) in (NetworkConfigs.Param.firstPage, searchText) },
            loadMoreAction
                .filter { [weak self] in self?.footerState.isLoadEnabled ?? false }
                .withLatestFrom($page)
                .map { currentPage -> (Int, String?) in (currentPage + 1, nil) }
        )

        loadGiftsAction
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.viewState = .loading
                self?.footerState = .loading
            })
            .flatMapLatestToResult { [weak self] page, keyword -> AnyPublisher<PaginationResponse<[Gift]>, Error> in
                guard let self else {
                    return Empty<PaginationResponse<[Gift]>, Error>().eraseToAnyPublisher()
                }
                return self.giftsNetworkRepository
                    .getGiftsInShop(name: keyword, page: page, pageSize: self.pageSize)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(response):
                    if response.pagination.page == NetworkConfigs.Param.firstPage {
                        self.model = SearchGiftsModel(
                            coinModel: self.model?.coinModel,
                            myGiftString: self.model?.myGiftString,
                            giftsResponse: response
                        )
                    } else {
                        let data = self.model?.giftsResponse.data ?? [] + response.data
                        self.model = SearchGiftsModel(
                            coinModel: self.model?.coinModel,
                            myGiftString: self.model?.myGiftString,
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

        $searchText
            .map { $0.trimmed }
            .removeDuplicates()
            .flatMapLatestToResult { [weak self] string in
                guard let self else {
                    return Empty<[GiftKeyword], Error>().eraseToAnyPublisher()
                }
                return self.giftKeywordLocalRepository.observeKeywords(string)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(model):
                    self.keywords = model
                case .failure:
                    break
                }
            }
            .store(in: &cancellables)
    }

    private func configureActions() {
        searchAction
            .withLatestFrom($searchText)
            .map { $0.trimmed }
            .filter { !$0.isEmpty }
            .removeDuplicates()
            .sink { [weak self] keyword in
                let keyword = GiftKeyword(keyword: keyword)
                self?.giftKeywordLocalRepository.saveKeyword(keyword)
            }
            .store(in: &cancellables)
        clearGiftKeywordsAction
            .sink { [weak self] in
                self?.giftKeywordLocalRepository.deleteAll()
            }
            .store(in: &cancellables)
        removeKeywordAction
            .sink { [weak self] in
                self?.giftKeywordLocalRepository.delete($0)
            }
            .store(in: &cancellables)
    }
}

extension SearchGiftsViewModel {
    private func getData() -> AnyPublisher<SearchGiftsModel, Error> {
        Publishers.CombineLatest3(
            coinExchangeUseCases
                .getCoin(),
            giftsNetworkRepository
                .getMyGifts(page: NetworkConfigs.Param.firstPage, pageSize: pageSize)
                .map { [weak self] response in
                    guard let self else { return "" }
                    if response.data.count <= pageSize {
                        return "\(response.data.count)"
                    } else {
                        return "\(response.data.count)+"
                    }
                },
            giftsNetworkRepository.getGiftsInShop(page: NetworkConfigs.Param.firstPage, pageSize: pageSize)
        )
        .map {
            SearchGiftsModel(coinModel: $0.0, myGiftString: $0.1, giftsResponse: $0.2)
        }
        .eraseToAnyPublisher()
    }
}
