//
//  CameraViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 20/07/2023.
//
//

import AVKit
import Combine
import Foundation

// MARK: - CameraViewModelDelegate

protocol CameraViewModelDelegate: AnyObject {}

// MARK: - CameraViewModel

final class CameraViewModel: ViewModel {
    // MARK: Public

    lazy var sessionQueue = DispatchQueue(label: "session_queue")
    lazy var captureSession: AVCaptureSession = {
        let captureSession = AVCaptureSession()
        return captureSession
    }()

    var configureHandler: (() -> Void)?

    // MARK: State

    @Published var previewImage: CGImage?

    // MARK: Action

    // MARK: Dependencies

    private weak var delegate: CameraViewModelDelegate?

    // MARK: Private

    private var isCaptureSessionConfigured = false
    private var cancellables = Set<AnyCancellable>()

    init(delegate: CameraViewModelDelegate? = nil) {
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        isAppearSubject
            .sink { [weak self] in
                $0 ? self?.start() : self?.stop()
            }
            .store(in: &cancellables)
    }
}

extension CameraViewModel {
    func start() {
        sessionQueue.async { [weak self] in
            guard let self else { return }
            
            if !isCaptureSessionConfigured {
                configureCaptureSession()
            }
            if !captureSession.isRunning {
                captureSession.startRunning()
            }
        }
    }

    func stop() {
        guard isCaptureSessionConfigured, captureSession.isRunning else { return }
        sessionQueue.async {
            self.captureSession.stopRunning()
        }
    }
}

extension CameraViewModel {
    private func configureCaptureSession() {
        defer {
            self.captureSession.commitConfiguration()
        }

        isCaptureSessionConfigured = false
        captureSession.beginConfiguration()

        guard let captureDevice = AVCaptureDevice.default(for: .video),
              let captureDeviceInput = try? AVCaptureDeviceInput(device: captureDevice),
              captureSession.canAddInput(captureDeviceInput) else {
            return
        }
        captureSession.addInput(captureDeviceInput)

        let captureVideoDataOutput = AVCaptureVideoDataOutput()
        guard captureSession.canAddOutput(captureVideoDataOutput) else {
            return
        }
        captureSession.addOutput(captureVideoDataOutput)
        captureVideoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "capture_video_data_autput"))

        configureHandler?()

        captureSession.connections
            .filter {
                $0.isVideoOrientationSupported
            }
            .forEach {
                $0.videoOrientation = UIDevice.current.captureVideoOrientation
            }

        isCaptureSessionConfigured = true
    }
}

// MARK: AVCaptureVideoDataOutputSampleBufferDelegate

extension CameraViewModel: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = sampleBuffer.imageBuffer else { return }
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        guard let cgImage = CIContext().createCGImage(ciImage, from: ciImage.extent) else { return }

        DispatchQueue.main.async { [weak self] in
            self?.previewImage = cgImage
        }
    }
}
