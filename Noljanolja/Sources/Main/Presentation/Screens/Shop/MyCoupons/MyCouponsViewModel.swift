//
//  MyCouponsViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 15/06/2023.
//
//

import _SwiftUINavigationState
import Combine
import Foundation

// MARK: - MyCouponsViewModelDelegate

protocol MyCouponsViewModelDelegate: AnyObject {}

// MARK: - MyCouponsViewModel

final class MyCouponsViewModel: ViewModel {
    // MARK: State

    @Published var myCoupons = [MyCoupon]()
    @Published var viewState = ViewState.content
    @Published var footerState = StatefullFooterViewState.normal
    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<MyCoupon>?

    // MARK: Navigations

    @Published var navigationType: MyCouponsNavigationType?

    // MARK: Action

    let loadMoreAction = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    private let giftsApi: GiftsAPIType
    private weak var delegate: MyCouponsViewModelDelegate?

    // MARK: Private

    private var page = 0
    private let pageSize = 20
    private var cancellables = Set<AnyCancellable>()

    init(giftsApi: GiftsAPIType = GiftsAPI.default,
         delegate: MyCouponsViewModelDelegate? = nil) {
        self.giftsApi = giftsApi
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureLoadData()
    }

    private func configureLoadData() {
        let loadDataAction = Publishers.Merge(
            isAppearSubject
                .receive(on: DispatchQueue.main)
                .first(where: { $0 })
                .mapToVoid(),
            loadMoreAction
                .receive(on: DispatchQueue.main)
                .filter { [weak self] in self?.footerState.isLoadEnabled ?? false }
                .mapToVoid()
        )

        loadDataAction
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.viewState = .loading
                self?.footerState = .loading
            })
            .flatMapLatestToResult { [weak self] _ -> AnyPublisher<PaginationResponse<[MyCoupon]>, Error> in
                guard let self else {
                    return Empty<PaginationResponse<[MyCoupon]>, Error>().eraseToAnyPublisher()
                }
                return self.giftsApi
                    .getMyGifts(page: self.page + 1, pageSize: self.pageSize)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(response):
                    if response.pagination.page == NetworkConfigs.Param.firstPage {
                        self.myCoupons = response.data
                    } else {
                        self.myCoupons.append(contentsOf: response.data)
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
