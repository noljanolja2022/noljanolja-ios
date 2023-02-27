//
//  MyPageViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/02/2023.
//
//

import Combine
import Foundation
import UIKit

// MARK: - MyPageViewModelDelegate

protocol MyPageViewModelDelegate: AnyObject {}

// MARK: - MyPageViewModelType

protocol MyPageViewModelType: ObservableObject {
    // MARK: State

    var viewState: ViewState<ProfileModel, Error> { get set }

    // MARK: Action

    var loadDataTrigger: PassthroughSubject<Void, Never> { get }
    var customerServiceCenterTrigger: PassthroughSubject<Void, Never> { get }
}

// MARK: - MyPageViewModel

final class MyPageViewModel: MyPageViewModelType {
    // MARK: Dependencies

    private weak var delegate: MyPageViewModelDelegate?
    private let profileService: ProfileServiceType

    // MARK: State

    @Published var viewState: ViewState<ProfileModel, Error> = .loading

    // MARK: Action

    let loadDataTrigger = PassthroughSubject<Void, Never>()
    let customerServiceCenterTrigger = PassthroughSubject<Void, Never>()

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: MyPageViewModelDelegate? = nil,
         profileService: ProfileServiceType = ProfileService()) {
        self.delegate = delegate
        self.profileService = profileService

        configure()
    }

    private func configure() {
        customerServiceCenterTrigger
            .sink(receiveValue: {
                if let url = URL(string: "tel://\(AppConfigs.App.customerServiceCenter)"),
                   UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            })
            .store(in: &cancellables)

        loadDataTrigger
            .combineLatest($viewState) { $1 }
            .filter { !$0.isContent }
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.viewState = .loading
            })
            .flatMap { [weak self] _ -> AnyPublisher<Result<ProfileModel, Error>, Never> in
                guard let self else { return Empty<Result<ProfileModel, Error>, Never>().eraseToAnyPublisher() }
                return self.profileService
                    .getProfile()
                    .eraseToResultAnyPublisher()
            }
            .sink(
                receiveValue: { [weak self] result in
                    switch result {
                    case let .success(profileModel):
                        self?.viewState = .content(profileModel)
                        logger.info("Get profile successful - Profile: name - \(profileModel.name ?? "")")
                    case let .failure(error):
                        self?.viewState = .error(error)
                        logger.error("Get profile failed - Error: \(error)")
                    }
                }
            )
            .store(in: &cancellables)
    }
}
