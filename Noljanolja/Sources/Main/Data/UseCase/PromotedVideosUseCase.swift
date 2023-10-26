//
//  PromotedVideosUseCase.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 18/09/2023.
//

import Combine
import Foundation

// MARK: - PromotedVideosUseCase

protocol PromotedVideosUseCase {}

// MARK: - PromotedVideosUseCaseImpl

final class PromotedVideosUseCaseImpl: PromotedVideosUseCase {
    static let shared = PromotedVideosUseCaseImpl()

    private let videoRepository: VideoRepository

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(videoRepository: VideoRepository = VideoRepositoryImpl.shared) {
        self.videoRepository = videoRepository
        configure()
    }

    private func configure() {
        videoRepository
            .getPromotedVideos(page: 1, pageSize: 100)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { promotedVideos in
                    guard let video = promotedVideos.first(where: { $0.autoPlay })?.video else { return }
                    VideoDetailViewModel.shared.show(videoId: video.id, contentType: .bottom)
                }
            )
            .store(in: &cancellables)
    }
}
