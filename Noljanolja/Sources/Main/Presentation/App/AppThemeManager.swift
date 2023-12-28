//
//  AppThemeManager.swift
//  Noljanolja
//
//  Created by duydinhv on 28/12/2023.
//

import Combine
import Foundation
import SwiftUIX

// MARK: - AppThemeManager

final class AppThemeManager: ObservableObject {
    static let shared = AppThemeManager()

    let changeThemeAction = PassthroughSubject<AppTheme, Never>()

    var cancellables = Set<AnyCancellable>()
    @Published var theme: AppTheme = UserDefaults.standard.appTheme

    init() {
        bindingData()
    }

    private func bindingData() {
        changeThemeAction
            .sink(receiveValue: { [weak self] theme in
                UserDefaults.standard.appTheme = theme
                self?.theme = theme
            })
            .store(in: &cancellables)
    }
}
