//
//  ImageDetailViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 26/04/2023.
//
//

import _SwiftUINavigationState
import Combine
import Foundation
import SDWebImage

// MARK: - ImageDetailViewModelDelegate

// import SVProgressHUD

protocol ImageDetailViewModelDelegate: AnyObject {
    func sendImage(_ image: UIImage)
}

// MARK: - ImageDetailViewModel

final class ImageDetailViewModel: ViewModel {
    // MARK: State

    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Void>?

    // MARK: Navigation

    @Published var fullScreenCoverType: ImageDetailFullScreenCoverType?

    // MARK: Action

    let downloadImageAction = PassthroughSubject<Void, Never>()
    let editImageAction = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    let imageUrl: URL
    private weak var delegate: ImageDetailViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(imageUrl: URL,
         delegate: ImageDetailViewModelDelegate? = nil) {
        self.imageUrl = imageUrl
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        let imageUrl = imageUrl

        downloadImageAction
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
            .flatMapLatestToResult {
                SDWebImageManager.shared.loadImagePublisher(with: imageUrl, progress: nil)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                self.isProgressHUDShowing = false
                switch result {
                case let .success(image):
                    guard let image else { return }
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    self.alertState = AlertState(
                        title: TextState("Saved"),
                        message: TextState(""),
                        dismissButton: .cancel(TextState("OK"))
                    )
                case .failure:
                    break
                }
            }
            .store(in: &cancellables)

        editImageAction
            .handleEvents(receiveOutput: { [weak self] _ in self?.isProgressHUDShowing = true })
            .flatMapLatestToResult {
                SDWebImageManager.shared.loadImagePublisher(with: imageUrl, progress: nil)
            }
            .sink { [weak self] result in
                guard let self else { return }
                self.isProgressHUDShowing = false
                switch result {
                case let .success(image):
                    guard let image else { return }
                    self.fullScreenCoverType = .edit(image)
                case .failure:
                    break
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: ImageEditorViewModelDelegate

extension ImageDetailViewModel: ImageEditorViewModelDelegate {
    func finishEditing(_ image: UIImage) {
        fullScreenCoverType = .editerResult(image)
    }
}

// MARK: ImageEditorResultViewModelDelegate

extension ImageDetailViewModel: ImageEditorResultViewModelDelegate {
    func sendImage(_ image: UIImage) {
        delegate?.sendImage(image)
    }
}

private extension SDWebImageManager {
    func loadImagePublisher(with url: URL?,
                            options: SDWebImageOptions = [],
                            progress progressBlock: SDImageLoaderProgressBlock?) -> AnyPublisher<UIImage?, Error> {
        AnyPublisher { subscriber in
            self.loadImage(
                with: url,
                options: options,
                progress: progressBlock,
                completed: { image, _, error, _, _, _ in
                    if let error {
                        subscriber.send(completion: .failure(error))
                    } else {
                        subscriber.send(image)
                        subscriber.send(completion: .finished)
                    }
                }
            )
            return AnyCancellable {}
        }
    }
}
