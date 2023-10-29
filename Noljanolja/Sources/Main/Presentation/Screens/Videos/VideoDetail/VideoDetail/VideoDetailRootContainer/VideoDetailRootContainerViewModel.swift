//
//  VideoDetailRootContainerViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 15/09/2023.
//
//

import Combine
import Foundation
import SwiftUIX

// MARK: - VideoDetailRootContainerViewModelDelegate

protocol VideoDetailRootContainerViewModelDelegate: AnyObject {}

// MARK: - VideoDetailRootContainerViewModel

final class VideoDetailRootContainerViewModel: ViewModel {
    // MARK: State

    @Published private(set) var bottomPadding: CGFloat = 0

    // MARK: Action

    // MARK: Dependencies

    private weak var delegate: VideoDetailRootContainerViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: VideoDetailRootContainerViewModelDelegate? = nil) {
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        VideoDetailViewModel.shared.$contentType
            .receive(on: DispatchQueue.main)
            .sink { [weak self] contentType in
                let bottomPadding: CGFloat = {
                    switch contentType {
                    case .bottom:
                        return VideoDetailViewContentType.bottom.playerHeight
                    case .full, .pictureInPicture, .hide:
                        return 0
                    }
                }()
                withAnimation(.easeInOut(duration: 0.3)) {
                    self?.bottomPadding = bottomPadding
                }
            }
            .store(in: &cancellables)
    }
}
