//
//  FriendDetailViewModel.swift
//  Noljanolja
//
//  Created by duydinhv on 16/11/2023.
//

import _SwiftUINavigationState
import Combine
import Foundation

// MARK: - FriendDetailViewModelDelegate

protocol FriendDetailViewModelDelegate {}

// MARK: - FriendDetailViewModel

class FriendDetailViewModel: ViewModel {
    let user: User

    @Published var myPoint: Int?
    private let memberInfoSubject = CurrentValueSubject<LoyaltyMemberInfo?, Never>(nil)
    private let memberInfoUseCase: MemberInfoUseCases
    private var cancellables = Set<AnyCancellable>()

    init(user: User, memberInfoUseCase: MemberInfoUseCases = MemberInfoUseCasesImpl.default) {
        self.user = user
        self.memberInfoUseCase = memberInfoUseCase

        super.init()
        configure()
    }

    private func configure() {
        configureLoadData()
    }

    private func configureLoadData() {
        memberInfoSubject
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.myPoint = $0.point
            }
            .store(in: &cancellables)

        isAppearSubject
            .first(where: { $0 })
            .receive(on: DispatchQueue.main)
            .flatMapLatestToResult { [weak self] _ in
                guard let self else {
                    return Empty<LoyaltyMemberInfo, Error>().eraseToAnyPublisher()
                }
                return self.memberInfoUseCase.getLoyaltyMemberInfo()
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(memberInfo):
                    self.memberInfoSubject.send(memberInfo)
                case .failure:
                    break
                }
            }
            .store(in: &cancellables)
    }
}
