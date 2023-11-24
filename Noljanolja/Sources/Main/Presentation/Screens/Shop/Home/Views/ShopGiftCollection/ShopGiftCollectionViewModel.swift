//
//  ShopGiftCollectionViewModel.swift
//  Noljanolja
//
//  Created by Duy Dinh on 21/11/2023.
//

import Combine
import Foundation

// MARK: - ShopGiftCollectionListener

protocol ShopGiftCollectionListener: AnyObject {}

// MARK: - ShopGiftCollectionViewModel

final class ShopGiftCollectionViewModel: ViewModel {
    // MARK: State

    @Published var viewState = ViewState.loading
    @Published var footerState = StatefullFooterViewState.normal
    @Published var models = [Gift]()

    // MARK: Navigations

    @Published var navigationType: ShopGiftNavigationType?
    @Published var fullScreenCoverType: ShopGiftFullScreenCoverType?

    // MARK: Action

    let loadMoreAction = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    private let giftsNetworkRepository: GiftsNetworkRepository
    private weak var listener: ShopGiftListener?
    private let categoryId: Int?

    // MARK: Private

    @Published private var page = 0
    private let pageSize = 20
    private var cancellables = Set<AnyCancellable>()

    init(giftsNetworkRepository: GiftsNetworkRepository = GiftsNetworkRepositoryImpl.default,
         listener: ShopGiftListener? = nil,
         categoryId: Int? = nil) {
        self.giftsNetworkRepository = giftsNetworkRepository
        self.listener = listener
        self.categoryId = categoryId
        super.init()

        configure()
    }

    private func configure() {
        configureLoadData()
    }

    private func configureLoadData() {
        let loadDataAction = Publishers.Merge(
            isAppearSubject
                .first(where: { $0 })
                .map { _ -> Int in NetworkConfigs.Param.firstPage },
            loadMoreAction
                .filter { [weak self] in self?.footerState.isLoadEnabled ?? false }
                .withLatestFrom($page)
                .map { currentPage -> Int in currentPage + 1 }
        )

        loadDataAction
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.viewState = .loading
                self?.footerState = .loading
            })
            .flatMapLatestToResult { [weak self] _ -> AnyPublisher<PaginationResponse<[Gift]>, Error> in
                guard let self else {
                    return Empty<PaginationResponse<[Gift]>, Error>().eraseToAnyPublisher()
                }
                return self.giftsNetworkRepository
                    .getGiftsInShop(isFeatured: true)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(response):
                    if response.pagination.page == NetworkConfigs.Param.firstPage {
                        self.models = response.data
                    } else {
                        self.models = self.models + response.data
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
