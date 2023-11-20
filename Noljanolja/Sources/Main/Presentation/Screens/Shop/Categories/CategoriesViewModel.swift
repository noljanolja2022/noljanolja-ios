//
//  CategoriesViewModel.swift
//  Noljanolja
//
//  Created by duydinhv on 20/11/2023.
//

import Combine
import Foundation

final class CategoriesViewModel: ViewModel {
    @Published var viewState = ViewState.loading
    @Published var footerState = StatefullFooterViewState.normal
    @Published var models: [GiftCategory] = []
    @Published var selectedIndex = 0
    @Published private var page = 0

    private let giftsNetworkRepository: GiftsNetworkRepository
    private var cancellables = Set<AnyCancellable>()
    private let pageSize = 20

    let loadMoreAction = PassthroughSubject<Void, Never>()

    init(giftsNetworkRepository: GiftsNetworkRepository = GiftsNetworkRepositoryImpl.default) {
        self.giftsNetworkRepository = giftsNetworkRepository
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
            .flatMapLatestToResult { [weak self] page -> AnyPublisher<PaginationResponse<[GiftCategory]>, Error> in
                guard let self else {
                    return Empty<PaginationResponse<[GiftCategory]>, Error>().eraseToAnyPublisher()
                }
                return self.giftsNetworkRepository.getGiftsCategories(page: page, pageSize: self.pageSize)
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
                    self.models.insert(GiftCategory(id: self.models.endIndex + 1, name: "All"), at: 0)
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
