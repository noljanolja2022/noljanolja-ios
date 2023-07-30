//
//  VideoActionViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 26/07/2023.
//
//

import Combine
import Foundation

// MARK: - VideoActionViewModelDelegate

protocol VideoActionViewModelDelegate: AnyObject {
    func didSelectItem(_ model: VideoActionItemViewModel)
}

// MARK: - VideoActionViewModel

final class VideoActionViewModel: ViewModel {
    // MARK: State

    @Published var items = [VideoActionItemViewModel]()

    // MARK: Action

    let selectItemAction = PassthroughSubject<VideoActionItemViewModel, Never>()

    // MARK: Dependencies

    let video: Video
    private weak var delegate: VideoActionViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(video: Video,
         delegate: VideoActionViewModelDelegate? = nil) {
        self.video = video
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        items = VideoActionItemViewModel.allCases

        selectItemAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.delegate?.didSelectItem($0)
            }
            .store(in: &cancellables)
    }
}
