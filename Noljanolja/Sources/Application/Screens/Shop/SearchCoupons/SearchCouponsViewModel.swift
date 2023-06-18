//
//  SearchCouponsViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 19/06/2023.
//  
//

import Combine
import Foundation
import _SwiftUINavigationState

// MARK: -  SearchCouponsViewModelDelegate

protocol  SearchCouponsViewModelDelegate: AnyObject {}

// MARK: - SearchCouponsViewModel

final class SearchCouponsViewModel: ViewModel {
    // MARK: State

    @Published var viewState = ViewState.content
    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Void>?
    @Published var coupons = [Coupon]()

    // MARK: Navigations

    @Published var navigationType: SearchCouponsNavigationType?


    // MARK: Action

    // MARK: Dependencies

    private weak var delegate: SearchCouponsViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: SearchCouponsViewModelDelegate? = nil) {
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {}
}
