//
//  SelectCountryViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 25/02/2023.
//
//

import Combine
import Foundation

// MARK: - SelectCountryViewModelDelegate

protocol SelectCountryViewModelDelegate: AnyObject {
    func didSelectCountry(_ country: Country)
}

// MARK: - SelectCountryViewModelType

protocol SelectCountryViewModelType:
    ViewModelType where State == SelectCountryViewModel.State, Action == SelectCountryViewModel.Action {}

extension SelectCountryViewModel {
    struct State {
        var searchString = ""
        var selectedCountry: Country
        var countries = [Country]()
    }

    enum Action {
        case loadData
        case selectCountry(Country)
    }
}

// MARK: - SelectCountryViewModel

final class SelectCountryViewModel: SelectCountryViewModelType {
    // MARK: State

    @Published var state: State

    // MARK: Dependencies

    private weak var delegate: SelectCountryViewModelDelegate?

    // MARK: Action

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(state: State,
         delegate: SelectCountryViewModelDelegate? = nil) {
        self.state = state
        self.delegate = delegate

        configure()
    }

    func send(_ action: Action) {
        switch action {
        case .loadData:
            state.countries = Country.countries.sorted(by: \.name)
        case let .selectCountry(country):
            delegate?.didSelectCountry(country)
        }
    }

    private func configure() {
        $state
            .map { $0.searchString }
            .removeDuplicates()
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .map { text in
                Country.countries
                    .filter {
                        guard !text.isEmpty else { return true }
                        return $0.code.lowercased().contains(text.lowercased())
                            || $0.phoneCode.lowercased().contains(text.lowercased())
                            || $0.name.lowercased().contains(text.lowercased())
                    }
                    .sorted(by: \.name)
            }
            .sink(receiveValue: { [weak self] in self?.state.countries = $0 })
            .store(in: &cancellables)
    }
}
