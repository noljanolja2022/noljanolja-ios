//
//  ChatInputExpandMenuViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 20/04/2023.
//
//

import Combine
import Foundation
import UIKit

// MARK: - ChatInputExpandMenuViewModelDelegate

protocol ChatInputExpandMenuViewModelDelegate: AnyObject {
    func didSelectImages(_ images: [UIImage])
}

// MARK: - ChatInputExpandMenuViewModel

final class ChatInputExpandMenuViewModel: ViewModel {
    // MARK: State

    // MARK: Navigations

    @Published var fullScreenCoverType: ChatInputExpandMenuFullScreenCoverType?

    // MARK: Action

    let sendImagesAction = PassthroughSubject<[UIImage], Never>()

    // MARK: Dependencies

    private weak var delegate: ChatInputExpandMenuViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: ChatInputExpandMenuViewModelDelegate? = nil) {
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        sendImagesAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] images in
                self?.delegate?.didSelectImages(images)
            }
            .store(in: &cancellables)
    }
}
