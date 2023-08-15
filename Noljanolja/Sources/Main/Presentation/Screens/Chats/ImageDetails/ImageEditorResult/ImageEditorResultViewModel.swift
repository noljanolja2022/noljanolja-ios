//
//  ImageEditorResultViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 28/04/2023.
//
//

import _SwiftUINavigationState
import Combine
import Foundation
import UIKit

// MARK: - ImageEditorResultViewModelDelegate

protocol ImageEditorResultViewModelDelegate: AnyObject {
    func imageEditorResultViewModel(sendImage image: UIImage)
}

// MARK: - ImageEditorResultViewModel

final class ImageEditorResultViewModel: ViewModel {
    // MARK: State

    @Published var alertState: AlertState<Void>?

    // MARK: Action

    let saveAction = PassthroughSubject<Void, Never>()
    let sendAction = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    let image: UIImage
    private weak var delegate: ImageEditorResultViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(image: UIImage,
         delegate: ImageEditorResultViewModelDelegate? = nil) {
        self.image = image
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        saveAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil)
                self.alertState = AlertState(
                    title: TextState(L10n.commonSaved),
                    message: TextState(""),
                    dismissButton: .cancel(TextState("OK"))
                )
            }
            .store(in: &cancellables)

        sendAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.delegate?.imageEditorResultViewModel(sendImage: self.image)
            }
            .store(in: &cancellables)
    }
}
