//
//  SendRequestViewModel.swift
//  Noljanolja
//
//  Created by duydinhv on 03/01/2024.
//

import Combine
import Foundation

// MARK: - SendRequestType

enum SendRequestType {
    case send, request

    var title: String {
        switch self {
        case .send:
            return "Send Points"
        case .request:
            return "Request Points"
        }
    }

    var successAlert: String {
        switch self {
        case .send:
            return "Send Complete"
        case .request:
            return "Request Complete"
        }
    }
}

// MARK: - SendRequestViewModelDelegate

protocol SendRequestViewModelDelegate: AnyObject {
    func requestSendSuccess(type: SendRequestType)
}

// MARK: - SendRequestViewModel

final class SendRequestViewModel: ViewModel {
    let type: SendRequestType
    let user: User
    @Published var myPoint: Int?
    @Published var memberId: String?
    @Published var viewState = ViewState.content
    @Published var error: Error?
    @Published var isProgressHUDShowing = false
    @Published var point = ""
    @Published var fullScreenCoverType: SendRequestFullScreenCoverType?
    @Published var showError = false
    @Published var isSuccess = false
    let continueAction = PassthroughSubject<Void, Never>()
    let yesAction = PassthroughSubject<Void, Never>()

    private let memberInfoSubject = CurrentValueSubject<LoyaltyMemberInfo?, Never>(nil)
    private let memberInfoUseCase: MemberInfoUseCases
    private let sendRequestPointUseCase: SendRequestPointsUseCases
    private var cancellables = Set<AnyCancellable>()
    private weak var delegate: SendRequestViewModelDelegate?

    init(user: User,
         type: SendRequestType,
         memberInfoUseCase: MemberInfoUseCases = MemberInfoUseCasesImpl.default,
         sendRequestPointUseCase: SendRequestPointsUseCases = SendRequestPointsUseCasesImpl.shared,
         delegate: SendRequestViewModelDelegate) {
        self.memberInfoUseCase = memberInfoUseCase
        self.sendRequestPointUseCase = sendRequestPointUseCase
        self.user = user
        self.type = type
        self.delegate = delegate
        super.init()
        configure()
    }

    private func configure() {
        configureLoadData()
        configureAction()
    }

    private func configureLoadData() {
        memberInfoSubject
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.myPoint = $0.point
                self?.memberId = $0.memberId
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

    private func configureAction() {
        yesAction
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] in
                self?.isProgressHUDShowing = true
                self?.showError = false
            })
            .flatMapLatestToResult { [weak self] in
                guard let self, let point = Int(self.point) else {
                    return Empty<SendRequestPointsModel, Error>().eraseToAnyPublisher()
                }
                switch type {
                case .send:
                    return self.sendRequestPointUseCase.sendPoints(point, self.user.id)
                case .request:
                    return self.sendRequestPointUseCase.requestPoint(point, self.user.id)
                }
            }
            .sink { [weak self] result in
                guard let self else { return }
                self.isProgressHUDShowing = false
                switch result {
                case .success:
                    self.isSuccess = true
                    self.delegate?.requestSendSuccess(type: self.type)
                case .failure:
                    self.showError = true
                }
            }
            .store(in: &cancellables)
    }
}
