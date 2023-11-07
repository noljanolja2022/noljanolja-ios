//
//  MyRankingViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 21/05/2023.
//
//

import Combine
import Foundation

// MARK: - MyRankingViewModelDelegate

protocol MyRankingViewModelDelegate: AnyObject {}

// MARK: - MyRankingViewModel

final class MyRankingViewModel: ViewModel {
    // MARK: State

    @Published var viewState = ViewState.content
    @Published var model: MyRankingModel?

    // MARK: Action

    // MARK: Dependencies

    private let userUseCases: UserUseCases
    private let memberInfoUseCase: MemberInfoUseCases
    private weak var delegate: MyRankingViewModelDelegate?

    // MARK: Private

    private let currentUserSubject = CurrentValueSubject<User?, Never>(nil)
    private let memberInfoSubject = CurrentValueSubject<LoyaltyMemberInfo?, Never>(nil)
    private var cancellables = Set<AnyCancellable>()

    init(userUseCases: UserUseCases = UserUseCasesImpl.default,
         memberInfoUseCase: MemberInfoUseCases = MemberInfoUseCasesImpl.default,
         delegate: MyRankingViewModelDelegate? = nil) {
        self.userUseCases = userUseCases
        self.memberInfoUseCase = memberInfoUseCase
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureActions()
        configureLoadData()
    }

    private func configureLoadData() {
        memberInfoSubject
            .compactMap { $0 }
            .map { MyRankingModel(memberInfo: $0) }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.model = $0 }
            .store(in: &cancellables)

        isAppearSubject
            .first(where: { $0 })
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in self?.viewState = .loading })
            .flatMapLatestToResult { [weak self] _ -> AnyPublisher<LoyaltyMemberInfo, Error> in
                guard let self else {
                    return Empty<LoyaltyMemberInfo, Error>().eraseToAnyPublisher()
                }
                return self.memberInfoUseCase.getLoyaltyMemberInfo()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(model):
                    self.memberInfoSubject.send(model)
                    self.viewState = .content
                case .failure:
                    self.viewState = .error
                }
            }
            .store(in: &cancellables)

        userUseCases
            .getCurrentUserPublisher()
            .sink(receiveValue: { [weak self] in self?.currentUserSubject.send($0) })
            .store(in: &cancellables)
    }

    private func configureActions() {}
}
