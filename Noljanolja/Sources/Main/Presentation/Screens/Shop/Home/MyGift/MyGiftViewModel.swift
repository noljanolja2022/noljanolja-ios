import Combine
import Foundation

// MARK: - MyGiftListener

protocol MyGiftListener: AnyObject {}

// MARK: - MyGiftViewModel

final class MyGiftViewModel: ViewModel {
    // MARK: State
    
    @Published var viewState = ViewState.loading
    @Published var footerState = StatefullFooterViewState.normal
    @Published var models = [MyGift]()

    // MARK: Navigations

    @Published var navigationType: MyGiftNavigationType?
    @Published var fullScreenCoverType: MyGiftFullScreenCoverType?

    // MARK: Action

    let loadMoreAction = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    private let giftsNetworkRepository: GiftsNetworkRepository
    private weak var listener: ShopGiftListener?

    // MARK: Private
    
    @Published private var page = 0
    private let pageSize = 20
    private var cancellables = Set<AnyCancellable>()

    init(giftsNetworkRepository: GiftsNetworkRepository = GiftsNetworkRepositoryImpl.default,
         listener: ShopGiftListener? = nil) {
        self.giftsNetworkRepository = giftsNetworkRepository
        self.listener = listener
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
            .flatMapLatestToResult { [weak self] page -> AnyPublisher<PaginationResponse<[MyGift]>, Error> in
                guard let self else {
                    return Empty<PaginationResponse<[MyGift]>, Error>().eraseToAnyPublisher()
                }
                return self.giftsNetworkRepository
                    .getMyGifts(page: page, pageSize: self.pageSize)
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
