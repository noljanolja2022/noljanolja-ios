//
//  UpdateCurrentUserViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 04/03/2023.
//
//

import Combine
import Foundation
import SwiftUINavigation
import UIKit

// MARK: - UpdateCurrentUserViewModelDelegate

protocol UpdateCurrentUserViewModelDelegate: AnyObject {
    func didUpdateCurrentUser()
}

// MARK: - UpdateCurrentUserViewModelType

protocol UpdateCurrentUserViewModelType:
    ViewModelType where State == UpdateCurrentUserViewModel.State, Action == UpdateCurrentUserViewModel.Action {}

extension UpdateCurrentUserViewModel {
    struct State {
        var image: UIImage?
        var name = ""
        var birthday: Date?
        var gender: String?

        var actionSheetType: ActionSheetType?

        enum ActionSheetType: Int, Identifiable {
            case avatar
            case gender

            var id: Int { rawValue }
        }
    }

    enum Action {
        case openAvatarActionSheet
        case openGenderActionSheet
        case updateCurrentUser
    }
}

// MARK: - UpdateCurrentUserViewModel

final class UpdateCurrentUserViewModel: UpdateCurrentUserViewModelType {
    // MARK: State

    @Published var state: State

    // MARK: Dependencies

    private weak var delegate: UpdateCurrentUserViewModelDelegate?

    // MARK: Action

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(state: State = State(),
         delegate: UpdateCurrentUserViewModelDelegate? = nil) {
        self.state = state
        self.delegate = delegate

        configure()
    }

    func send(_ action: Action) {
        switch action {
        case .openAvatarActionSheet:
            state.actionSheetType = .avatar
        case .openGenderActionSheet:
            state.actionSheetType = .gender
        case .updateCurrentUser:
            delegate?.didUpdateCurrentUser()
        }
    }

    private func configure() {}
}
