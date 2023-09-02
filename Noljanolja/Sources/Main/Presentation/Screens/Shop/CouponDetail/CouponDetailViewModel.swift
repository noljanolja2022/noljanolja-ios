//
//  CouponDetailViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 13/06/2023.
//
//

import _SwiftUINavigationState
import Combine
import Foundation

// MARK: - CouponDetailViewModelDelegate

protocol CouponDetailViewModelDelegate: AnyObject {}

// MARK: - CouponDetailViewModel

final class CouponDetailViewModel: ViewModel {
    // MARK: State

    @Published var viewState = ViewState.content
    @Published var model: CouponDetailModel?
    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<CouponDetailAlertActionType>?

    // MARK: Action

    let buyCouponAction = PassthroughSubject<Void, Never>()
    let displayMyCouponAction = PassthroughSubject<MyCoupon, Never>()

    // MARK: Dependencies

    private let couponDetailInputTypeSubject: CurrentValueSubject<CouponDetailInputType, Never>
    private let giftsApi: GiftsAPIType
    private let memberInfoUseCase: MemberInfoUseCases
    private weak var delegate: CouponDetailViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(couponDetailInputType: CouponDetailInputType,
         giftsApi: GiftsAPIType = GiftsAPI.default,
         memberInfoUseCase: MemberInfoUseCases = MemberInfoUseCasesImpl.default,
         delegate: CouponDetailViewModelDelegate? = nil) {
        self.couponDetailInputTypeSubject = CurrentValueSubject<CouponDetailInputType, Never>(couponDetailInputType)
        self.giftsApi = giftsApi
        self.memberInfoUseCase = memberInfoUseCase
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureBindData()
        configureLoadData()
        configureActions()
    }

    private func configureBindData() {
        displayMyCouponAction
            .sink { [weak self] in
                self?.couponDetailInputTypeSubject.send(.myCoupon($0))
            }
            .store(in: &cancellables)
    }

    private func configureLoadData() {
        isAppearSubject
            .first { $0 }
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in self?.viewState = .loading })
            .flatMapLatestToResult { [weak self] _ in
                guard let self else {
                    return Empty<CouponDetailModel, Error>().eraseToAnyPublisher()
                }
                return self.getData()
            }
            .receive(on: DispatchQueue.main)
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
    }

    private func configureActions() {
        buyCouponAction
            .withLatestFrom(couponDetailInputTypeSubject)
            .compactMap { $0.coupon }
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
            .flatMapLatestToResult { [weak self] coupon in
                guard let self else {
                    return Empty<MyCoupon, Error>().eraseToAnyPublisher()
                }
                return self.buyCoupon(coupon.id)
            }
            .sink { [weak self] result in
                guard let self else { return }
                self.isProgressHUDShowing = false
                switch result {
                case let .success(model):
                    self.alertState = AlertState(
                        title: TextState(L10n.commonSuccess),
                        message: TextState(L10n.shopOrderCouponSuccess),
                        primaryButton: .destructive(TextState(L10n.shopLater.uppercased()), action: .send(.back)),
                        secondaryButton: .default(TextState(L10n.commonUse.uppercased()), action: .send(.viewDetail(model)))
                    )
                case .failure:
                    self.alertState = AlertState(
                        title: TextState(L10n.commonErrorTitle),
                        message: TextState(L10n.commonErrorDescription),
                        dismissButton: .cancel(TextState("OK"))
                    )
                }
            }
            .store(in: &cancellables)
    }
}

extension CouponDetailViewModel {
    private func getData() -> AnyPublisher<CouponDetailModel, Error> {
        Publishers.CombineLatest(
            memberInfoUseCase.getLoyaltyMemberInfo(),
            couponDetailInputTypeSubject
                .setFailureType(to: Error.self)
        )
        .receive(on: DispatchQueue.global(qos: .background))
        .map { CouponDetailModel(memberInfo: $0.0, couponDetailInputType: $0.1) }
        .eraseToAnyPublisher()
    }

    private func buyCoupon(_ id: Int) -> AnyPublisher<MyCoupon, Error> {
        giftsApi.buyCoupon(id)
            .flatMapLatest { [weak self] myCoupon in
                guard let self else {
                    return Empty<MyCoupon, Error>().eraseToAnyPublisher()
                }
                return self.memberInfoUseCase.getLoyaltyMemberInfo()
                    .map { _ in myCoupon }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
