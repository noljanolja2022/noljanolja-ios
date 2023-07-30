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
    func chatInputExpandMenuViewModel(sendImages images: [UIImage])
}

// MARK: - ChatInputExpandMenuViewModel

final class ChatInputExpandMenuViewModel: ViewModel {
    // MARK: State

    // MARK: Navigations

    @Published var fullScreenCoverType: ChatInputExpandMenuFullScreenCoverType?

    // MARK: Action

    // MARK: Dependencies

    private weak var delegate: ChatInputExpandMenuViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: ChatInputExpandMenuViewModelDelegate? = nil) {
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {}
}

// MARK: ChatInputImagePreviewViewModelDelegate

extension ChatInputExpandMenuViewModel: ChatInputImagePreviewViewModelDelegate {
    func chatInputImagePreviewViewModel(sendImage image: UIImage) {
        delegate?.chatInputExpandMenuViewModel(sendImages: [image])
    }
}
