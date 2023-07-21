//
//  ShopHomeViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 13/06/2023.
//
//

import _SwiftUINavigationState
import Combine
import Foundation

// MARK: - ShopHomeViewModelDelegate

protocol ShopHomeViewModelDelegate: AnyObject {}

// MARK: - ShopHomeViewModel

final class ShopHomeViewModel: ViewModel {
    // MARK: State

    @Published var viewState = ViewState.content
    @Published var model = ShopHomeModel()
    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Void>?

    // MARK: Navigations

    @Published var navigationType: ShopHomeNavigationType?

    // MARK: Action

    // MARK: Dependencies

    private let giftsApi: GiftsAPIType
    private let memberInfoUseCase: MemberInfoUseCases
    private weak var delegate: ShopHomeViewModelDelegate?

    // MARK: Private
    
    private let pageSize = 20
    private var cancellables = Set<AnyCancellable>()

    init(giftsApi: GiftsAPIType = GiftsAPI.default,
         memberInfoUseCase: MemberInfoUseCases = MemberInfoUseCasesImpl.default,
         delegate: ShopHomeViewModelDelegate? = nil) {
        self.giftsApi = giftsApi
        self.memberInfoUseCase = memberInfoUseCase
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureBindData()
        configureLoadData()
    }

    private func configureBindData() {}

    private func configureLoadData() {
        isAppearSubject
            .first { $0 }
            .handleEvents(receiveOutput: { [weak self] _ in self?.viewState = .loading })
            .flatMapLatestToResult { [weak self] _ in
                guard let self else {
                    return Empty<ShopHomeModel, Error>().eraseToAnyPublisher()
                }
                return self.getData()
            }
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(model):
                    self.model = model
                    self.viewState = .content
                case .failure:
                    self.viewState = .error
                }
            }
            .store(in: &cancellables)

        isAppearSubject
            .filter { $0 }
            .dropFirst()
            .flatMapLatestToResult { [weak self] _ in
                guard let self else {
                    return Empty<[MyCoupon], Error>().eraseToAnyPublisher()
                }
                return self.giftsApi
                    .getMyGifts(page: 1, pageSize: self.pageSize)
                    .map { $0.data }
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(model):
                    self.model = ShopHomeModel(
                        memberInfo: self.model.memberInfo,
                        myCoupons: model,
                        shopCoupons: self.model.shopCoupons
                    )
                case .failure:
                    break
                }
            }
            .store(in: &cancellables)
    }
}

extension ShopHomeViewModel {
    private func getData() -> AnyPublisher<ShopHomeModel, Error> {
        Publishers.CombineLatest3(
            memberInfoUseCase
                .getLoyaltyMemberInfo(),
            giftsApi
                .getMyGifts(page: 1, pageSize: pageSize)
                .map { $0.data },
            giftsApi
                .getGiftsInShop(page: 1, pageSize: pageSize)
                .map { $0.data }
        )
        .map(ShopHomeModel.init)
        .eraseToAnyPublisher()
    }
}
