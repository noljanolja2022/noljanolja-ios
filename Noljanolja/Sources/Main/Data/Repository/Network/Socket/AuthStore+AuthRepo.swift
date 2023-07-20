//
//  Auth.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 03/05/2023.
//

import shared

// MARK: - AuthStore + AuthRepo

extension AuthStore: AuthRepo {
    func getAuthToken() async throws -> String? {
        getToken()
    }
}
