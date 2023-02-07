//
//  AuthorizationStore.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 07/02/2023.
//

import Foundation
import KeychainAccess

private extension Keychain {
    static let `default`: Keychain = {
        guard let bunldeId = Bundle.main.bundleIdentifier else { fatalError("Cannot get Bundle ID for: Bundle.main") }
        return Keychain(service: bunldeId)
    }()
}

// MARK: - AuthorizationStore

final class AuthorizationStore {
    static let `default` = AuthorizationStore(keychain: .default)

    private let keychain: Keychain

    init(keychain: Keychain) {
        self.keychain = keychain
    }

    func saveToken(_ token: String) {
        keychain[string: "token"] = token
    }

    func getToken() -> String? {
        keychain[string: "token"]
    }

    func clearToken() {
        keychain[string: "token"] = nil
    }
}
