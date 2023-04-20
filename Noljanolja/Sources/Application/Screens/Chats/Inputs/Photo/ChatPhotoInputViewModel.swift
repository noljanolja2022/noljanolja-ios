//
//  ChatPhotoInputViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/03/2023.
//
//

import Combine
import Foundation
import Photos
import UIKit

// MARK: - ChatPhotoInputViewModelDelegate

protocol ChatPhotoInputViewModelDelegate: AnyObject {}

// MARK: - ChatPhotoInputViewModel

final class ChatPhotoInputViewModel: ViewModel {
    // MARK: State

    @Published var viewState = ViewState.loading

    // MARK: Action

    // MARK: Dependencies

    private weak var delegate: ChatPhotoInputViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: ChatPhotoInputViewModelDelegate? = nil) {
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        isAppearSubject
            .filter { $0 }
            .sink { [weak self] _ in self?.checkPermissionState() }
            .store(in: &cancellables)
    }

    private func checkPermissionState() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] _ in
                self?.checkPermissionState()
            }
        case .authorized, .limited:
            viewState = .content
        case .restricted, .denied:
            viewState = .error
        @unknown default:
            viewState = .error
        }
    }
}
