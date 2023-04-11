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

// MARK: - ChatPhotoInputViewModelType

protocol ChatPhotoInputViewModelType: ObservableObject {
    // MARK: State

    var viewState: ViewState { get set }

    // MARK: Action

    var loadDataSubject: PassthroughSubject<Void, Never> { get }
}

// MARK: - ChatPhotoInputViewModel

final class ChatPhotoInputViewModel: ChatPhotoInputViewModelType {
    // MARK: State

    @Published var viewState = ViewState.loading

    // MARK: Action

    let loadDataSubject = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    private weak var delegate: ChatPhotoInputViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: ChatPhotoInputViewModelDelegate? = nil) {
        self.delegate = delegate

        configure()
    }

    private func configure() {
        loadDataSubject
            .first()
            .sink { [weak self] in self?.checkPermissionState() }
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
