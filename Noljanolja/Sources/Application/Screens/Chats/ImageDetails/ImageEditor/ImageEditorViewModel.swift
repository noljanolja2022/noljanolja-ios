//
//  ImageEditorViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 27/04/2023.
//
//

import Combine
import Foundation
import UIKit

// MARK: - ImageEditorViewModelDelegate

protocol ImageEditorViewModelDelegate: AnyObject {
    func finishEditing(_ image: UIImage)
}

// MARK: - ImageEditorViewModel

final class ImageEditorViewModel: ViewModel {
    // MARK: State

    // MARK: Action

    let finishEditingAction = PassthroughSubject<UIImage, Never>()

    // MARK: Dependencies

    let image: UIImage
    private weak var delegate: ImageEditorViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(image: UIImage,
         delegate: ImageEditorViewModelDelegate? = nil) {
        self.image = image
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        finishEditingAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.delegate?.finishEditing($0)
            }
            .store(in: &cancellables)
    }
}
