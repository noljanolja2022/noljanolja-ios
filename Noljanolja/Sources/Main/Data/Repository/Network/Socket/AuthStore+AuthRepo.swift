//
//  Auth.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 03/05/2023.
//

import shared

// MARK: - AuthLocalRepositoryImpl + AuthRepo

extension AuthLocalRepositoryImpl: AuthRepo {
    func getAuthToken() async throws -> String? {
        getToken()
    }
}
