//
//  SelectCountryViewModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 25/02/2023.
//
//

import Combine

// MARK: - SelectCountryViewModelDelegate

protocol SelectCountryViewModelDelegate: AnyObject {
    func didSelectCountry(_ country: Country)
}

// MARK: - SelectCountryViewModelType

protocol SelectCountryViewModelType: ObservableObject {
    // MARK: State

    var searchText: String { get set }
    var countries: [Country] { get set }

    // MARK: Action

    var selectCountryTrigger: CurrentValueSubject<Country?, Never> { get }
}

// MARK: - SelectCountryViewModel

final class SelectCountryViewModel: SelectCountryViewModelType {
    // MARK: Dependencies

    private weak var delegate: SelectCountryViewModelDelegate?

    // MARK: State

    @Published var searchText = ""
    @Published var countries: [Country] = Country.countries.sorted(by: \.name)

    // MARK: Action

    let selectCountryTrigger: CurrentValueSubject<Country?, Never>

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    init(delegate: SelectCountryViewModelDelegate? = nil,
         selectedCountry: Country? = nil) {
        self.delegate = delegate
        self.selectCountryTrigger = CurrentValueSubject<Country?, Never>(selectedCountry)

        configure()
    }

    private func configure() {
        $searchText
            .map { text in
                Country.countries
                    .filter {
                        guard !text.isEmpty else { return true }
                        return $0.name.lowercased().contains(text.lowercased())
                    }
                    .sorted(by: \.name)
            }
            .sink(receiveValue: { [weak self] in self?.countries = $0 })
            .store(in: &cancellables)

        selectCountryTrigger
            .dropFirst()
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] in self?.delegate?.didSelectCountry($0) })
            .store(in: &cancellables)
    }
}
