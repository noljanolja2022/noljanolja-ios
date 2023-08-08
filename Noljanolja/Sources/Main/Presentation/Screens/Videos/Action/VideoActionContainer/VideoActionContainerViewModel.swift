//
//  VideoActionContainerViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 26/07/2023.
//
//

import Combine
import Foundation
import SwiftUIX

// MARK: - VideoActionContainerViewModelDelegate

protocol VideoActionContainerViewModelDelegate: AnyObject {}

// MARK: - VideoActionContainerViewModel

final class VideoActionContainerViewModel: ViewModel {
    // MARK: State

    // MARK: Navigations

    @Published var fullScreenCoverType: VideoActionContainerFullScreenCoverType?

    // MARK: Action

    let closeAction = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    let video: Video
    private weak var delegate: VideoActionContainerViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(video: Video,
         delegate: VideoActionContainerViewModelDelegate? = nil) {
        self.video = video
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        isAppearSubject
            .first(where: { $0 })
            .sink { [weak self] _ in
                withoutAnimation { [weak self] in
                    self?.fullScreenCoverType = .more
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: VideoActionViewModelDelegate

extension VideoActionContainerViewModel: VideoActionViewModelDelegate {
    func didSelectItem(_ model: VideoActionItemViewModel) {
        switch model {
        case .share: fullScreenCoverType = .share
        case .copyLink, .ignore: break
        }
    }
}

// MARK: ShareVideoViewModelDelegate

extension VideoActionContainerViewModel: ShareVideoViewModelDelegate {
    func openShareDetail(_ user: User) {
        withoutAnimation {
            fullScreenCoverType = .shareDetail(user)
        }
    }
}

// MARK: ShareVideoDetailViewModelDelegate

extension VideoActionContainerViewModel: ShareVideoDetailViewModelDelegate {
    func didShare() {
        closeAction.send()
    }
}
