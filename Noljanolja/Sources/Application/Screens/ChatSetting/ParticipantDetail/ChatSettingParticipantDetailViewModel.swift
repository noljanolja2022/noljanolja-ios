//
//  ChatSettingParticipantDetailViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/04/2023.
//
//

import Combine
import Foundation

// MARK: - ChatSettingParticipantDetailViewModelDelegate

protocol ChatSettingParticipantDetailViewModelDelegate: AnyObject {
    func didSelectAction(user: User, action: ChatSettingUserDetailAction)
}

// MARK: - ChatSettingParticipantDetailViewModel

final class ChatSettingParticipantDetailViewModel: ViewModel {
    // MARK: State

    // MARK: Action

    let actionSubject = PassthroughSubject<ChatSettingUserDetailAction, Never>()

    // MARK: Dependencies

    let participantModel: ChatSettingParticipantModel
    private weak var delegate: ChatSettingParticipantDetailViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(participantModel: ChatSettingParticipantModel,
         delegate: ChatSettingParticipantDetailViewModelDelegate? = nil) {
        self.participantModel = participantModel
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        actionSubject
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] action in
                guard let self else { return }
                self.delegate?.didSelectAction(
                    user: self.participantModel.user,
                    action: action
                )
            })
            .store(in: &cancellables)
    }
}
