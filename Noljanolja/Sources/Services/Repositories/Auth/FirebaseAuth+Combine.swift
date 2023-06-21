//
//  FirebaseAuth+Combine.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 07/02/2023.
//

import Combine
import FirebaseAuth
import Foundation

extension Auth {
    func signOutCombine() -> Future<Void, Error> {
        Future { [weak self] promise in
            do {
                try self?.signOut()
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
    }
}
