//
//  SearchGiftsViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 19/06/2023.
//
//

import _SwiftUINavigationState
import Combine
import Foundation

// MARK: - SearchGiftsViewModelDelegate

protocol SearchGiftsViewModelDelegate: AnyObject {}

// MARK: - SearchGiftsViewModel

final class SearchGiftsViewModel: ViewModel {
    // MARK: State

    @Published var viewState = ViewState.content
    @Published var footerState = StatefullFooterViewState.normal
    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Void>?
    @Published var searchText = ""
    @Published var isKeywordHidden = true
    @Published var keywords = [GiftKeyword]()
    @Published var model: SearchGiftsModel?

    // MARK: Navigations

    @Published var navigationType: SearchGiftsNavigationType?

    // MARK: Action

    let searchAction = PassthroughSubject<Void, Never>()
    let clearGiftKeywordsAction = PassthroughSubject<Void, Never>()
    let removeKeywordAction = PassthroughSubject<GiftKeyword, Never>()

    // MARK: Dependencies

    private let giftKeywordLocalRepository: GiftKeywordLocalRepository
    private weak var delegate: SearchGiftsViewModelDelegate?

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(giftKeywordLocalRepository: GiftKeywordLocalRepository = GiftKeywordLocalRepositoryImpl.shared,
         delegate: SearchGiftsViewModelDelegate? = nil) {
        self.giftKeywordLocalRepository = giftKeywordLocalRepository
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureLoadData()
        configureActions()
    }

    private func configureLoadData() {
        $searchText
            .map { $0.trimmed }
            .removeDuplicates()
            .flatMapLatestToResult { [weak self] string in
                guard let self else {
                    return Empty<[GiftKeyword], Error>().eraseToAnyPublisher()
                }
                return self.giftKeywordLocalRepository.observeKeywords(string)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(model):
                    self.keywords = model
                case .failure:
                    break
                }
            }
            .store(in: &cancellables)
    }

    private func configureActions() {
        searchAction
            .withLatestFrom($searchText)
            .map { $0.trimmed }
            .filter { !$0.isEmpty }
            .sink { [weak self] keyword in
                let keyword = GiftKeyword(keyword: keyword)
                self?.giftKeywordLocalRepository.saveKeyword(keyword)
                self?.navigationType = .results(keyword.keyword)
            }
            .store(in: &cancellables)
        clearGiftKeywordsAction
            .sink { [weak self] in
                self?.giftKeywordLocalRepository.deleteAll()
            }
            .store(in: &cancellables)
        removeKeywordAction
            .sink { [weak self] in
                self?.giftKeywordLocalRepository.delete($0)
            }
            .store(in: &cancellables)
    }
}
