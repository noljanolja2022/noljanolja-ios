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

// MARK: - SelectCountryViewModel

final class SelectCountryViewModel: ViewModel {
    // MARK: State

    @Published var searchString = ""
    @Published var selectedCountry: Country
    @Published var countries = [Country]()

    // MARK: Action

    // MARK: Dependencies

    private let countryAPI: CountryAPIType
    private weak var delegate: SelectCountryViewModelDelegate?

    // MARK: Private

    private let loadDataSubject = PassthroughSubject<Void, Never>()

    private let allCountries = CurrentValueSubject<[Country], Never>([])

    private var cancellables = Set<AnyCancellable>()

    init(selectedCountry: Country,
         countryAPI: CountryAPIType = CountryAPI(),
         delegate: SelectCountryViewModelDelegate? = nil) {
        self.selectedCountry = selectedCountry
        self.countryAPI = countryAPI
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        allCountries
            .sink(receiveValue: { [weak self] in self?.countries = $0 })
            .store(in: &cancellables)

        $searchString
            .removeDuplicates()
            .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main)
            .withLatestFrom(allCountries) { ($0, $1) }
            .map { text, countries in
                countries
                    .filter {
                        guard !text.isEmpty else { return true }
                        return $0.code.lowercased().contains(text.lowercased())
                            || $0.phoneCode.lowercased().contains(text.lowercased())
                            || $0.name.lowercased().contains(text.lowercased())
                    }
                    .sorted(by: \.name)
            }
            .sink(receiveValue: { [weak self] in self?.countries = $0 })
            .store(in: &cancellables)

        loadDataSubject
            .flatMapLatestToResult { [weak self] in
                guard let self else {
                    return Empty<[Country], Error>().eraseToAnyPublisher()
                }
                return self.countryAPI.getCountries()
            }
            .sink { [weak self] result in
                switch result {
                case let .success(countries):
                    self?.allCountries.send(countries)
                case .failure:
                    break
                }
            }
            .store(in: &cancellables)

        $selectedCountry
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                self?.delegate?.didSelectCountry($0)
            })
            .store(in: &cancellables)

        isAppearSubject
            .filter { $0 }
            .first()
            .sink(receiveValue: { [weak self] _ in self?.loadDataSubject.send() })
            .store(in: &cancellables)
    }
}
