//
//  ChatInputImagePreviewViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 12/05/2023.
//
//

import _SwiftUINavigationState
import Combine
import Foundation
import UIKit

// MARK: - ChatInputImagePreviewViewModelDelegate

protocol ChatInputImagePreviewViewModelDelegate: AnyObject {
    func chatInputImagePreviewViewModel(sendImage image: UIImage)
}

// MARK: - ChatInputImagePreviewViewModel

final class ChatInputImagePreviewViewModel: ViewModel {
    // MARK: State

    @Published var alertState: AlertState<Void>?

    // MARK: Action
    
    let downloadImageAction = PassthroughSubject<Void, Never>()
    let sendImageAction = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    let image: UIImage
    private weak var delegate: ChatInputImagePreviewViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(image: UIImage,
         delegate: ChatInputImagePreviewViewModelDelegate? = nil) {
        self.image = image
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        downloadImageAction
            .sink { [weak self] in
                guard let self else { return }
                UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil)
                self.alertState = AlertState(
                    title: TextState("Saved"),
                    message: TextState(""),
                    dismissButton: .cancel(TextState("OK"))
                )
            }
            .store(in: &cancellables)

        sendImageAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.delegate?.chatInputImagePreviewViewModel(sendImage: self.image)
            }
            .store(in: &cancellables)
    }
}
