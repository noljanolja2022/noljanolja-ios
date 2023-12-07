//
//  ProfileActionViewModel.swift
//  Noljanolja
//
//  Created by kii on 05/12/2023.
//
import Combine
import Foundation

// MARK: - ProfileActionViewModelDelegate

protocol ProfileActionViewModelDelegate: AnyObject {
    func profileActionViewModel(didSelectItem item: ProfileActionItemViewModel)
}

// MARK: - ProfileActionViewModel

final class ProfileActionViewModel: ViewModel {
    @Published var items = [ProfileActionItemViewModel]()

    let selectItemAction = PassthroughSubject<ProfileActionItemViewModel, Never>()

    private weak var delegate: ProfileActionViewModelDelegate?

    private var cancellables = Set<AnyCancellable>()

    let closeAction = PassthroughSubject<Void, Never>()

    init(delegate: ProfileActionViewModelDelegate) {
        super.init()
        self.delegate = delegate
        configure()
    }

    private func configure() {
        items = ProfileActionItemViewModel.allCases

        selectItemAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.closeAction.send()
                self?.delegate?.profileActionViewModel(didSelectItem: $0)
            }
            .store(in: &cancellables)
    }
}

// MARK: - ProfileActionItemViewModel

enum ProfileActionItemViewModel: CaseIterable {
    case openCamera
    case selectFromAlbum

    var imageName: String {
        switch self {
        case .openCamera: return ImageAssets.icCameraFill.name
        case .selectFromAlbum: return ImageAssets.icImage.name
        }
    }

    var title: String {
        switch self {
        case .openCamera: return L10n.updateProfileAvatarOpenCamera
        case .selectFromAlbum: return L10n.updateProfileAvatarFromAlbum
        }
    }
}
