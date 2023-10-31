//
//  SearchVideosViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 25/07/2023.
//
//

import _SwiftUINavigationState
import Combine
import Foundation

// MARK: - SearchVideosViewModelDelegate

protocol SearchVideosViewModelDelegate: AnyObject {}

// MARK: - SearchVideosViewModel

final class SearchVideosViewModel: ViewModel {
    // MARK: State

    @Published var viewState = ViewState.content
    @Published var footerState = StatefullFooterViewState.normal
    @Published var isProgressHUDShowing = false
    @Published var alertState: AlertState<Void>?
    @Published var searchText = ""
    @Published var isKeywordHidden = true
    @Published var keywords = [VideoKeyword]()
    @Published var model: PaginationResponse<[Video]>?

    // MARK: Navigations

    @Published var navigationType: SearchVideosNavigationType?

    // MARK: Action

    let searchAction = PassthroughSubject<Void, Never>()
    let clearKeywordsAction = PassthroughSubject<Void, Never>()
    let removeKeywordAction = PassthroughSubject<VideoKeyword, Never>()
    let loadMoreAction = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    private let videoKeywordLocalRepository: VideoKeywordLocalRepository
    private let videoRepository: VideoRepository
    private weak var delegate: SearchVideosViewModelDelegate?

    // MARK: Private

    @Published private var page = 0
    private let pageSize = 20
    private var cancellables = Set<AnyCancellable>()

    init(videoKeywordLocalRepository: VideoKeywordLocalRepository = VideoKeywordLocalRepositoryImpl.shared,
         videoRepository: VideoRepository = VideoRepositoryImpl.shared,
         delegate: SearchVideosViewModelDelegate? = nil) {
        self.videoKeywordLocalRepository = videoKeywordLocalRepository
        self.videoRepository = videoRepository
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureLoadData()
        configureActions()
    }

    private func configureLoadData() {
        isAppearSubject
            .first(where: { $0 })
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.viewState = .loading
                self?.footerState = .loading
            })
            .flatMapLatestToResult { [weak self] _ -> AnyPublisher<PaginationResponse<[Video]>, Error> in
                guard let self else {
                    return Empty<PaginationResponse<[Video]>, Error>().eraseToAnyPublisher()
                }
                return self.videoRepository
                    .getVideos(page: NetworkConfigs.Param.firstPage, pageSize: pageSize)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(model):
                    self.model = model
                    self.page = model.pagination.page
                    self.viewState = .content
                    self.footerState = model.pagination.total == self.page ? .noMoreData : .normal
                case .failure:
                    self.viewState = .error
                    self.footerState = .error
                }
            })
            .store(in: &cancellables)

        let loadAction = Publishers.Merge(
            searchAction
                .withLatestFrom($searchText)
                .map { keyword in
                    let trimmedKeyword = keyword.trimmed
                    return trimmedKeyword.isEmpty ? nil : trimmedKeyword
                }
                .removeDuplicates()
                .map { searchText -> (Int, String?) in (NetworkConfigs.Param.firstPage, searchText) },
            loadMoreAction
                .filter { [weak self] in self?.footerState.isLoadEnabled ?? false }
                .withLatestFrom($page)
                .map { currentPage -> (Int, String?) in (currentPage + 1, nil) }
        )

        loadAction
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.viewState = .loading
                self?.footerState = .loading
            })
            .flatMapLatestToResult { [weak self] page, keyword -> AnyPublisher<PaginationResponse<[Video]>, Error> in
                guard let self else {
                    return Empty<PaginationResponse<[Video]>, Error>().eraseToAnyPublisher()
                }
                return self.videoRepository
                    .getVideos(query: keyword, page: page, pageSize: self.pageSize)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(response):
                    if response.pagination.page == NetworkConfigs.Param.firstPage {
                        self.model = response
                    } else {
                        let data = self.model?.data ?? [] + response.data
                        self.model = PaginationResponse<[Video]>(data: data, pagination: response.pagination)
                    }
                    self.page = response.pagination.page
                    self.viewState = .content
                    self.footerState = response.pagination.total == self.page ? .noMoreData : .normal
                case .failure:
                    self.viewState = .error
                    self.footerState = .error
                }
            })
            .store(in: &cancellables)

        $searchText
            .map { $0.trimmed }
            .removeDuplicates()
            .flatMapLatestToResult { [weak self] string in
                guard let self else {
                    return Empty<[VideoKeyword], Error>().eraseToAnyPublisher()
                }
                return self.videoKeywordLocalRepository.observeKeywords(string)
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
            .removeDuplicates()
            .sink { [weak self] keyword in
                let keyword = VideoKeyword(keyword: keyword)
                self?.videoKeywordLocalRepository.saveKeyword(keyword)
            }
            .store(in: &cancellables)
        clearKeywordsAction
            .sink { [weak self] in
                self?.videoKeywordLocalRepository.deleteAll()
            }
            .store(in: &cancellables)
        removeKeywordAction
            .sink { [weak self] in
                self?.videoKeywordLocalRepository.delete($0)
            }
            .store(in: &cancellables)
    }
}
