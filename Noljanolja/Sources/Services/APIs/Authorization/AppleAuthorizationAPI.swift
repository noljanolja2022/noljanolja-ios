//
//  AppleAuthorizationAPI.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 04/02/2023.
//

import AuthenticationServices
import Combine
import CryptoKit
import Foundation

// MARK: - AppleAuthorizationError

enum AppleAuthorizationError: Error {
    case tokenNotExit
}

// MARK: - AppleAuthorizationAPI

final class AppleAuthorizationAPI: NSObject {
    private var currentNonce: String?
    private let successTrigger = PassthroughSubject<(String, String), Never>()
    private let failTrigger = PassthroughSubject<Error, Never>()
    private var cancellables = Set<AnyCancellable>()

    func signIn() -> Future<(String, String), Error> {
        Future { [weak self] promise in
            guard let self else { return }
            self.signInWithApple()
            self.successTrigger
                .sink { promise(.success($0)) }
                .store(in: &self.cancellables)
            self.failTrigger
                .sink { promise(.failure($0)) }
                .store(in: &self.cancellables)
        }
    }
}

// MARK: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate

extension AppleAuthorizationAPI: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        UIApplication.shared.rootKeyWindow ?? UIWindow(frame: UIScreen.main.bounds)
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            if let nonce = currentNonce,
               let idToken = credential.identityToken,
               let idTokenString = String(data: idToken, encoding: .utf8) {
                successTrigger.send((nonce, idTokenString))
            } else {
                failTrigger.send(AppleAuthorizationError.tokenNotExit)
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        logger.error("Sign in with apple failed")
        failTrigger.send(error)
    }
}

extension AppleAuthorizationAPI {
    private func signInWithApple() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0..<16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }

        return result
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()

        return hashString
    }
}
