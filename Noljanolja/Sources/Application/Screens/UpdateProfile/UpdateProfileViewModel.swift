//
//  UpdateProfileViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 04/03/2023.
//
//

import Combine
import Foundation
import SwiftUINavigation
import UIKit

// MARK: - UpdateProfileViewModelDelegate

protocol UpdateProfileViewModelDelegate: AnyObject {}

// MARK: - UpdateProfileViewModelType

protocol UpdateProfileViewModelType:
    ViewModelType where State == UpdateProfileViewModel.State, Action == UpdateProfileViewModel.Action {}

extension UpdateProfileViewModel {
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
    }
}

// MARK: - UpdateProfileViewModel

final class UpdateProfileViewModel: UpdateProfileViewModelType {
    // MARK: State

    @Published var state: State

    // MARK: Dependencies

    private weak var delegate: UpdateProfileViewModelDelegate?

    // MARK: Action

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(state: State = State(),
         delegate: UpdateProfileViewModelDelegate? = nil) {
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
        }
    }

    private func configure() {}
}
