//
//  ChatAttachmentTabViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 26/08/2023.
//
//

import Combine
import Foundation

// MARK: - ChatAttachmentTabViewModelDelegate

protocol ChatAttachmentTabViewModelDelegate: AnyObject {}

// MARK: - ChatAttachmentTabViewModel

final class ChatAttachmentTabViewModel: ViewModel {
    // MARK: State

    @Published var viewState = ViewState.content
    @Published var footerState = StatefullFooterViewState.normal
    @Published var models = [ConversationAttachment]()

    // MARK: Action

    let loadMoreAction = PassthroughSubject<Void, Never>()

    // MARK: Dependencies

    let conversation: Conversation
    private let type: ConversationAttachmentType
    private let conversationRepository: ConversationAPIType
    private weak var delegate: ChatAttachmentTabViewModelDelegate?

    // MARK: Private

    @Published private var page = 0
    private let pageSize = 20
    private var cancellables = Set<AnyCancellable>()

    init(conversation: Conversation,
         type: ConversationAttachmentType,
         conversationRepository: ConversationAPIType = ConversationAPI.default,
         delegate: ChatAttachmentTabViewModelDelegate? = nil) {
        self.conversation = conversation
        self.type = type
        self.conversationRepository = conversationRepository
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        configureLoadData()
    }

    private func configureLoadData() {
        let loadAction = Publishers.Merge(
            isAppearSubject
                .first(where: { $0 })
                .map { _ in NetworkConfigs.Param.firstPage },
            loadMoreAction
                .filter { [weak self] in self?.footerState.isLoadEnabled ?? false }
                .withLatestFrom($page)
                .map { $0 + 1 }
        )

        loadAction
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.viewState = .loading
                self?.footerState = .loading
            })
            .flatMapLatestToResult { [weak self] page -> AnyPublisher<PaginationResponse<[ConversationAttachment]>, Error> in
                guard let self else {
                    return Empty<PaginationResponse<[ConversationAttachment]>, Error>().eraseToAnyPublisher()
                }
                return self.conversationRepository
                    .getConversationAttachments(
                        conversationID: self.conversation.id,
                        types: [self.type],
                        page: page,
                        pageSize: self.pageSize
                    )
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(response):
                    if response.pagination.page == NetworkConfigs.Param.firstPage {
                        self.models = response.data
                    } else {
                        self.models = self.models + response.data
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
    }
}
