//
//  ScanQRViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 11/06/2023.
//
//

import _SwiftUINavigationState
import AVKit
import Combine
import Foundation
import UIKit

// MARK: - ScanQRViewModelDelegate

protocol ScanQRViewModelDelegate: AnyObject {}

// MARK: - ScanQRViewModel

final class ScanQRViewModel: ViewModel {
    // MARK: State

    @Published var image: UIImage?
    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Void>?

    lazy var cameraViewModel: CameraViewModel = {
        let cameraViewModel = CameraViewModel()
        cameraViewModel.configureHandler = {
            let metadataOutput = AVCaptureMetadataOutput()
            guard cameraViewModel.captureSession.canAddOutput(metadataOutput) else { return }
            cameraViewModel.captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        }
        return cameraViewModel
    }()

    // MARK: Navigations

    @Published var navigationType: ScanQRNavigationType?
    @Published var fullScreenCoverType: ScanQRFullScreenCoverType?

    // MARK: Action

    private let findUserAction = PassthroughSubject<String, Never>()
    private let qrCodeStringAction = PassthroughSubject<String, Never>()

    // MARK: Dependencies

    private weak var delegate: ScanQRViewModelDelegate?

    // MARK: Private

    private let userAPI: UserAPIType
    private var isQREnabled = true
    private var cancellables = Set<AnyCancellable>()

    init(userAPI: UserAPIType = UserAPI.default,
         delegate: ScanQRViewModelDelegate? = nil) {
        self.userAPI = userAPI
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureLoadData()
        configureActions()
    }

    private func configureLoadData() {
        $image
            .receive(on: DispatchQueue.global(qos: .background))
            .compactMap { $0?.detectQRCode().first }
            .sink(receiveValue: { [weak self] in
                self?.qrCodeStringAction.send($0)
            })
            .store(in: &cancellables)
    }

    private func configureActions() {
        findUserAction
            .throttle(for: 0.2, scheduler: DispatchQueue.main, latest: true)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isProgressHUDShowing = true
            })
            .flatMapLatestToResult { [weak self] userId in
                guard let self else {
                    return Empty<[User], Error>().eraseToAnyPublisher()
                }
                return self.userAPI.findUsers(phoneNumber: nil, friendId: userId)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                self.isProgressHUDShowing = false
                switch result {
                case let .success(model):
                    if model.isEmpty {
                        self.alertState = AlertState(
                            title: TextState(L10n.commonErrorTitle),
                            message: TextState(L10n.errorPhoneIsNotAvailable),
                            dismissButton: .cancel(TextState(L10n.commonCancel))
                        )
                    } else {
                        self.navigationType = .result(model)
                    }
                case .failure:
                    self.alertState = AlertState(
                        title: TextState(L10n.commonErrorTitle),
                        message: TextState(L10n.commonErrorDescription),
                        dismissButton: .cancel(TextState("OK"))
                    )
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                    self?.isQREnabled = true
                }
            }
            .store(in: &cancellables)

        qrCodeStringAction
            .compactMap {
                let components = $0.split(separator: ":")
                if components.count == 3,
                   components.first == "nolljanollja",
                   let userId = components.last {
                    return String(userId)
                } else {
                    return nil
                }
            }
            .sink(receiveValue: { [weak self] in
                self?.findUserAction.send($0)
            })
            .store(in: &cancellables)
    }
}

// MARK: AVCaptureMetadataOutputObjectsDelegate

extension ScanQRViewModel: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard isQREnabled,
              navigationType == nil,
              let metadataObject = metadataObjects.first,
              let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
              let stringValue = readableObject.stringValue else { return }
        qrCodeStringAction.send(stringValue)
        isQREnabled = false
    }
}
