//
//  ParticipantDetailActionViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/04/2023.
//
//

import Combine
import Foundation

// MARK: - ParticipantDetailActionViewModelDelegate

protocol ParticipantDetailActionViewModelDelegate: AnyObject {
    func didSelectAction(user: User, action: ParticipantDetailActionType)
}

// MARK: - ParticipantDetailActionViewModel

final class ParticipantDetailActionViewModel: ViewModel {
    // MARK: State

    // MARK: Action

    let action = PassthroughSubject<ParticipantDetailActionType, Never>()

    // MARK: Dependencies

    let participantModel: ChatSettingParticipantModel
    private weak var delegate: ParticipantDetailActionViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(participantModel: ChatSettingParticipantModel,
         delegate: ParticipantDetailActionViewModelDelegate? = nil) {
        self.participantModel = participantModel
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        action
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
