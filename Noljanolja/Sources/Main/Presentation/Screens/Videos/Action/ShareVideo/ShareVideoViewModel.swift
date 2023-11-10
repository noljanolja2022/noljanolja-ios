//
//  ShareVideoViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 28/07/2023.
//
//

import Combine
import Foundation
import UIKit

// MARK: - ShareVideoViewModelDelegate

protocol ShareVideoViewModelDelegate: AnyObject {
    func shareVideoViewModel(didSelectUser user: User)
    func sharedSocial()
}

// MARK: - ShareVideoViewModel

final class ShareVideoViewModel: ViewModel {
    // MARK: State

    // MARK: Action

    let action = PassthroughSubject<User, Never>()
    let shareAction = PassthroughSubject<String, Never>()

    // MARK: Dependencies

    let video: Video

    private weak var delegate: ShareVideoViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(video: Video, delegate: ShareVideoViewModelDelegate? = nil) {
        self.delegate = delegate
        self.video = video
        super.init()

        configure()
    }

    private func configure() {
        configureActions()
    }

    private func configureActions() {
        action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.delegate?.shareVideoViewModel(didSelectUser: $0)
            }
            .store(in: &cancellables)

        shareAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] schemaURL in
                guard let self else { return }
                let urlEncode = self.video.url.stringEncode()
                guard let url = URL(string: schemaURL + "\(urlEncode)"),
                      UIApplication.shared.canOpenURL(url) else { return }
                UIApplication.shared.open(url)
                self.delegate?.sharedSocial()
            }
            .store(in: &cancellables)
    }
}
