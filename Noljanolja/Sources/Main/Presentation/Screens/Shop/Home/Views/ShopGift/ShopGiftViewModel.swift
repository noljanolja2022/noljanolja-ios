import Combine
import Foundation

// MARK: - ShopGiftListener

protocol ShopGiftListener: AnyObject {}

// MARK: - ShopGiftViewModel

final class ShopGiftViewModel: ViewModel {
    // MARK: State

    @Published var viewState = ViewState.loading
    @Published var footerState = StatefullFooterViewState.normal
    @Published var models: [Gift] = []

    // MARK: Navigations

    @Published var navigationType: ShopGiftNavigationType?
    @Published var fullScreenCoverType: ShopGiftFullScreenCoverType?

    // MARK: Action

    let loadMoreAction = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    private let giftsNetworkRepository: GiftsNetworkRepository
    private weak var listener: ShopGiftListener?
    private let categoryId: Int?
    private let brandId: String?
    private let skipGiftProduct: Gift?
    let title: String?

    // MARK: Private

    @Published private var page = 0
    private let pageSize = 20
    private var cancellables = Set<AnyCancellable>()

    init(giftsNetworkRepository: GiftsNetworkRepository = GiftsNetworkRepositoryImpl.default,
         listener: ShopGiftListener? = nil,
         categoryId: Int? = nil,
         brandId: String? = nil,
         skipGiftProduct: Gift? = nil,
         title: String? = nil) {
        self.giftsNetworkRepository = giftsNetworkRepository
        self.listener = listener
        self.categoryId = categoryId
        self.brandId = brandId
        self.skipGiftProduct = skipGiftProduct
        self.title = title
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
            .flatMapLatestToResult { [weak self] page -> AnyPublisher<PaginationResponse<[Gift]>, Error> in
                guard let self else {
                    return Empty<PaginationResponse<[Gift]>, Error>().eraseToAnyPublisher()
                }
                return self.giftsNetworkRepository
                    .getGiftsInShop(
                        categoryId: categoryId,
                        brandId: brandId,
                        page: page,
                        pageSize: self.pageSize
                    )
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(response):
                    var models = response.data
                    if let skipGiftProduct = self.skipGiftProduct {
                        models = response.data.filter { $0.id != skipGiftProduct.id }
                    }
                    if response.pagination.page == NetworkConfigs.Param.firstPage {
                        self.models = models
                    } else {
                        self.models = self.models + models
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
