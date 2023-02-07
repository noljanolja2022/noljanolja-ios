//
//  AuthorizationStoreAPI.swift
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

// MARK: - AuthorizationStoreAPI

final class AuthorizationStoreAPI {
    static let `default` = AuthorizationStoreAPI(keychain: .default)

    private let keychain: Keychain

    init(keychain: Keychain) {
        self.keychain = keychain
    }

    var token: String? {
        get {
            keychain[string: "token"]
        }
        set {
            guard let newValue else { return }
            keychain[string: "token"] = newValue
        }
    }
}
