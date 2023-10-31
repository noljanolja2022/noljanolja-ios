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
    func selectCountryViewModel(didSelectCountry country: Country)
}

// MARK: - SelectCountryViewModel

final class SelectCountryViewModel: ViewModel {
    // MARK: State

    @Published var searchString = ""
    @Published var selectedCountry: Country
    @Published var countries = [Country]()

    // MARK: Action

    // MARK: Dependencies

    private let countryNetworkRepository: CountryNetworkRepository
    private weak var delegate: SelectCountryViewModelDelegate?

    // MARK: Private

    private let loadDataSubject = PassthroughSubject<Void, Never>()

    private let allCountries = CurrentValueSubject<[Country], Never>([])

    private var cancellables = Set<AnyCancellable>()

    init(selectedCountry: Country,
         countryNetworkRepository: CountryNetworkRepository = CountryNetworkRepositoryImpl(),
         delegate: SelectCountryViewModelDelegate? = nil) {
        self.selectedCountry = selectedCountry
        self.countryNetworkRepository = countryNetworkRepository
        self.delegate = delegate
        super.init()

        configure()
    }

    private func configure() {
        allCountries
            .receive(on: DispatchQueue.main)
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
                            || $0.prefix.lowercased().contains(text.lowercased())
                            || $0.name.lowercased().contains(text.lowercased())
                    }
                    .sorted(by: \.name)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in self?.countries = $0 })
            .store(in: &cancellables)

        loadDataSubject
            .flatMapLatestToResult { [weak self] in
                guard let self else {
                    return Empty<[Country], Error>().eraseToAnyPublisher()
                }
                return self.countryNetworkRepository.getCountries()
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
                self?.delegate?.selectCountryViewModel(didSelectCountry: $0)
            })
            .store(in: &cancellables)

        isAppearSubject
            .first(where: { $0 })
            .sink(receiveValue: { [weak self] _ in self?.loadDataSubject.send() })
            .store(in: &cancellables)
    }
}
