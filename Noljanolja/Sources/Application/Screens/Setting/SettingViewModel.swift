//
//  SettingViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 06/03/2023.
//
//

import Combine
import Foundation

// MARK: - SettingViewModelDelegate

protocol SettingViewModelDelegate: AnyObject {}

// MARK: - SettingViewModel

final class SettingViewModel: ViewModel {
    // MARK: State

    @Published var name = ""
    @Published var phoneNumber = ""
    @Published var appVersion = ""

    // MARK: Navigations

    @Published var navigationType: SettingNavigationType?

    // MARK: Action

    // MARK: Dependencies

    private let userService: UserServiceType
    private weak var delegate: SettingViewModelDelegate?

    // MARK: Private

    private let currentUserSubject = CurrentValueSubject<User?, Never>(nil)
    private var cancellables = Set<AnyCancellable>()

    init(userService: UserServiceType = UserService.default,
         delegate: SettingViewModelDelegate? = nil) {
        self.userService = userService
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        appVersion = {
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            return appVersion ?? ""
        }()

        currentUserSubject
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] user in
                self?.name = user.name ?? ""
                self?.phoneNumber = user.phone
                    .flatMap {
                        $0.formatPhone()
                    }
                    .flatMap { string in
                        let maxLength = 4
                        if string.count > maxLength {
                            let hiddenString = Array(repeating: "*", count: string.count - maxLength).joined()
                            let shownString = string[string.index(string.endIndex, offsetBy: -4)...]
                            return hiddenString + shownString
                        } else {
                            return Array(repeating: "*", count: string.count).joined()
                        }
                    } ?? ""
            })
            .store(in: &cancellables)

        userService.currentUserPublisher
            .sink(receiveValue: { [weak self] in
                self?.currentUserSubject.send($0)
            })
            .store(in: &cancellables)
    }
}
