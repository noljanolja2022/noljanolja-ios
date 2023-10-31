//
//  SearchCouponsViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 19/06/2023.
//
//

import _SwiftUINavigationState
import Combine
import Foundation

// MARK: - SearchCouponsViewModelDelegate

protocol SearchCouponsViewModelDelegate: AnyObject {}

// MARK: - SearchCouponsViewModel

final class SearchCouponsViewModel: ViewModel {
    // MARK: State

    @Published var viewState = ViewState.content
    @Published var footerState = StatefullFooterViewState.normal
    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Void>?
    @Published var searchText = ""
    @Published var isKeywordHidden = true
    @Published var keywords = [CouponKeyword]()
    @Published var model: SearchCouponsModel?

    // MARK: Navigations

    @Published var navigationType: SearchCouponsNavigationType?

    // MARK: Action

    let searchAction = PassthroughSubject<Void, Never>()
    let clearCouponKeywordsAction = PassthroughSubject<Void, Never>()
    let removeKeywordAction = PassthroughSubject<CouponKeyword, Never>()
    let loadMoreAction = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    private let couponKeywordLocalRepository: CouponKeywordLocalRepository
    private let memberInfoUseCases: MemberInfoUseCases
    private let giftsApi: GiftsAPIType
    private weak var delegate: SearchCouponsViewModelDelegate?

    // MARK: Private

    @Published private var page = 0
    private let pageSize = 20
    private var cancellables = Set<AnyCancellable>()

    init(couponKeywordLocalRepository: CouponKeywordLocalRepository = CouponKeywordLocalRepositoryImpl.shared,
         memberInfoUseCases: MemberInfoUseCases = MemberInfoUseCasesImpl.default,
         giftsApi: GiftsAPIType = GiftsAPI.default,
         delegate: SearchCouponsViewModelDelegate? = nil) {
        self.couponKeywordLocalRepository = couponKeywordLocalRepository
        self.memberInfoUseCases = memberInfoUseCases
        self.giftsApi = giftsApi
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
            .first(where: { $0 })
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.viewState = .loading
                self?.footerState = .loading
            })
            .flatMapLatestToResult { [weak self] _ -> AnyPublisher<SearchCouponsModel, Error> in
                guard let self else {
                    return Empty<SearchCouponsModel, Error>().eraseToAnyPublisher()
                }
                return self.getData()
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(model):
                    self.model = model
                    self.page = model.couponsResponse.pagination.page
                    self.viewState = .content
                    self.footerState = model.couponsResponse.pagination.total == self.page ? .noMoreData : .normal
                case .failure:
                    self.viewState = .error
                    self.footerState = .error
                }
            })
            .store(in: &cancellables)

        let loadCouponsAction = Publishers.Merge(
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

        loadCouponsAction
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.viewState = .loading
                self?.footerState = .loading
            })
            .flatMapLatestToResult { [weak self] page, keyword -> AnyPublisher<PaginationResponse<[Coupon]>, Error> in
                guard let self else {
                    return Empty<PaginationResponse<[Coupon]>, Error>().eraseToAnyPublisher()
                }
                return self.giftsApi
                    .getGiftsInShop(name: keyword, page: page, pageSize: self.pageSize)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(response):
                    if response.pagination.page == NetworkConfigs.Param.firstPage {
                        self.model = SearchCouponsModel(
                            memberInfo: self.model?.memberInfo,
                            couponsResponse: response
                        )
                    } else {
                        let data = self.model?.couponsResponse.data ?? [] + response.data
                        self.model = SearchCouponsModel(
                            memberInfo: self.model?.memberInfo,
                            couponsResponse: PaginationResponse<[Coupon]>(data: data, pagination: response.pagination)
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
                    return Empty<[CouponKeyword], Error>().eraseToAnyPublisher()
                }
                return self.couponKeywordLocalRepository.observeKeywords(string)
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
                let keyword = CouponKeyword(keyword: keyword)
                self?.couponKeywordLocalRepository.saveKeyword(keyword)
            }
            .store(in: &cancellables)
        clearCouponKeywordsAction
            .sink { [weak self] in
                self?.couponKeywordLocalRepository.deleteAll()
            }
            .store(in: &cancellables)
        removeKeywordAction
            .sink { [weak self] in
                self?.couponKeywordLocalRepository.delete($0)
            }
            .store(in: &cancellables)
    }
}

extension SearchCouponsViewModel {
    private func getData() -> AnyPublisher<SearchCouponsModel, Error> {
        Publishers.CombineLatest(
            memberInfoUseCases.getLoyaltyMemberInfo(),
            giftsApi.getGiftsInShop(page: NetworkConfigs.Param.firstPage, pageSize: pageSize)
        )
        .map {
            SearchCouponsModel(memberInfo: $0.0, couponsResponse: $0.1)
        }
        .eraseToAnyPublisher()
    }
}
