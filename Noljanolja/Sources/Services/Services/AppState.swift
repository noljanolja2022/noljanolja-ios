//
//  AppState.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 11/02/2023.
//

import Combine
import Foundation

final class AppState {
    static let `default` = AppState()

    @Published var isLoading = false

    private init() {}
}
