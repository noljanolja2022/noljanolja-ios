//
//  PromotedVideosUseCases.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 18/09/2023.
//

import Combine
import Foundation

// MARK: - PromotedVideosUseCases

protocol PromotedVideosUseCases {}

// MARK: - PromotedVideosUseCasesImpl

final class PromotedVideosUseCasesImpl: PromotedVideosUseCases {
    static let shared = PromotedVideosUseCasesImpl()

    private let videoNetworkRepository: VideoNetworkRepository

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(videoNetworkRepository: VideoNetworkRepository = VideoNetworkRepositoryImpl.shared) {
        self.videoNetworkRepository = videoNetworkRepository
        configure()
    }

    private func configure() {
        videoNetworkRepository
            .getPromotedVideos(page: 1, pageSize: 100)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { promotedVideos in
                    guard let video = promotedVideos.first(where: { $0.autoPlay })?.video else { return }
                    VideoDetailViewModel.shared.show(videoId: video.id, contentType: .pictureInPicture)
                }
            )
            .store(in: &cancellables)
    }
}
