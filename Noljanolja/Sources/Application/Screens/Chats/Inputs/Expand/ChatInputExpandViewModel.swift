//
//  ChatInputExpandViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/03/2023.
//
//

import Combine
import Foundation
import UIKit

// MARK: - ChatInputExpandViewModelDelegate

protocol ChatInputExpandViewModelDelegate: AnyObject {
    func didSelectImages(_ images: [UIImage])
}

// MARK: - ChatInputExpandViewModel

final class ChatInputExpandViewModel: ViewModel {
    // MARK: State

    // MARK: Action

    // MARK: Dependencies

    private weak var delegate: ChatInputExpandViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: ChatInputExpandViewModelDelegate? = nil) {
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {}
}

// MARK: ChatInputExpandMenuViewModelDelegate

extension ChatInputExpandViewModel: ChatInputExpandMenuViewModelDelegate {
    func didSelectImages(_ images: [UIImage]) {
        delegate?.didSelectImages(images)
    }
}
