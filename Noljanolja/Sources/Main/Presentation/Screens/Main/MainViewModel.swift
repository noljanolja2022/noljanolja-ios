//
//  MainViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 06/09/2023.
//
//

import Combine
import Foundation

// MARK: - MainViewModelDelegate

protocol MainViewModelDelegate: AnyObject {
    func mainViewModelSignOut()
}

// MARK: - MainViewModel

final class MainViewModel: ViewModel {
    // MARK: State

    @Published var videoId: String?

    // MARK: Action

    // MARK: Dependencies

    private let videoManager: VideoManager
    private weak var delegate: MainViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(videoManager: VideoManager = VideoManager.shared,
         delegate: MainViewModelDelegate? = nil) {
        self.videoManager = videoManager
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        videoManager.selecttedVideoIdSubject
            .subscribe(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.videoId = $0
            }
            .store(in: &cancellables)
    }
}

// MARK: HomeViewModelDelegate

extension MainViewModel: HomeViewModelDelegate {
    func mainViewModelSignOut() {
        delegate?.mainViewModelSignOut()
    }
}
