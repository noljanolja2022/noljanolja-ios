//
//  CameraStatefulViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 20/07/2023.
//
//

import AVKit
import Combine
import Foundation

// MARK: - CameraStatefulViewModelDelegate

protocol CameraStatefulViewModelDelegate: AnyObject {}

// MARK: - CameraStatefulViewModel

final class CameraStatefulViewModel: ViewModel {
    // MARK: State

    @Published var viewState: ViewState?

    // MARK: Action

    // MARK: Dependencies

    let cameraViewModel: CameraViewModel
    private weak var delegate: CameraStatefulViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(cameraViewModel: CameraViewModel,
         delegate: CameraStatefulViewModelDelegate? = nil) {
        self.cameraViewModel = cameraViewModel
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        isAppearSubject
            .first(where: { $0 })
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.checkAuthorization { [weak self] status in
                    DispatchQueue.main.async { [weak self] in
                        self?.viewState = status ? .content : .error
                    }
                }
            }
            .store(in: &cancellables)
    }
}

extension CameraStatefulViewModel {
    private func checkAuthorization(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) {
                completion($0)
            }
        case .denied, .restricted:
            completion(false)
        @unknown default:
            completion(false)
        }
    }
}
