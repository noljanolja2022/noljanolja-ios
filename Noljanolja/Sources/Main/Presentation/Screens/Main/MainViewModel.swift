//
//  MainViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 06/09/2023.
//
//

import Combine
import Foundation
import SwiftUIX

// MARK: - MainViewModelDelegate

protocol MainViewModelDelegate: AnyObject {
    func mainViewModelSignOut()
}

// MARK: - MainViewModel

final class MainViewModel: ViewModel {
    // MARK: State

    @Published private(set) var bottomPadding: CGFloat = 0

    // MARK: Action

    let isHomeAppearSubject = CurrentValueSubject<Bool, Never>(false)

    // MARK: Dependencies

    private let promotedVideosUseCases: PromotedVideosUseCases
    private weak var delegate: MainViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(promotedVideosUseCases: PromotedVideosUseCases = PromotedVideosUseCasesImpl.shared,
         delegate: MainViewModelDelegate? = nil) {
        self.promotedVideosUseCases = promotedVideosUseCases
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureVideoDetail()
    }
    
    private func configureVideoDetail() {
        Publishers.CombineLatest(
            VideoDetailViewModel.shared.$contentType,
            isHomeAppearSubject
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] contentType, isHomeAppear in
            let bottomPadding: CGFloat = {
                switch contentType {
                case .bottom:
                    return isHomeAppear ? 0 : VideoDetailViewContentType.bottom.playerHeight + 8
                case .full, .pictureInPicture, .hide:
                    return 0
                }
            }()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                withAnimation(.easeInOut(duration: 0.3)) {
                    self?.bottomPadding = bottomPadding
                }
            }
        }
        .store(in: &cancellables)

        isHomeAppearSubject
            .sink { isAppear in
                let minimizeBottomPadding = {
                    if isAppear {
                        let tabBarHeight: CGFloat = 48
                        let dividerHeight: CGFloat = 1
                        return tabBarHeight + dividerHeight
                    } else {
                        return 0
                    }
                }()
                VideoDetailViewModel.shared.updateMinimizeBottomPadding(
                    minimizeBottomPadding
                )
            }
            .store(in: &cancellables)
    }
}

// MARK: HomeViewModelDelegate

extension MainViewModel: HomeViewModelDelegate {
    func homeViewModelSignOut() {
        delegate?.mainViewModelSignOut()
    }
}
