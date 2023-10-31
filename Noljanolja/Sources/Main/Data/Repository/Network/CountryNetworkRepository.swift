//
//  CountryNetworkRepositoryImpl.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 04/04/2023.
//

import Combine
import Foundation
import PhoneNumberKit

// MARK: - CountryNetworkRepository

protocol CountryNetworkRepository {
    func getDefaultCountry() -> Country
    func getCountries() -> AnyPublisher<[Country], Error>
}

// MARK: - CountryNetworkRepositoryImpl

final class CountryNetworkRepositoryImpl: CountryNetworkRepository {
    func getDefaultCountry() -> Country {
        let countryCode = "KR"
        let phoneNumberKit = PhoneNumberKit()
        let country = CountryCodePickerViewController.Country(for: countryCode, with: phoneNumberKit)
        return Country(
            country?.code ?? countryCode,
            country?.flag ?? "🇰🇷",
            country?.name ?? "Korea",
            country?.prefix ?? "+82"
        )
    }

    func getCountries() -> AnyPublisher<[Country], Error> {
        let phoneNumberKit = PhoneNumberKit()
        let countries = phoneNumberKit
            .allCountries()
            .compactMap { CountryCodePickerViewController.Country(for: $0, with: phoneNumberKit) }
            .map { Country($0.code, $0.flag, $0.name, $0.prefix) }

        return Just(countries)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func getCountry(countryCode: String?) -> Country? {
        guard let countryCode else { return nil }

        let phoneNumberKit = PhoneNumberKit()
        let fullCountryCode = countryCode.hasPrefix("+") ? countryCode : "+\(countryCode)"

        let allCountries = phoneNumberKit
            .allCountries()
            .compactMap { CountryCodePickerViewController.Country(for: $0, with: phoneNumberKit) }
            .map { Country($0.code, $0.flag, $0.name, $0.prefix) }
        let country = allCountries.first(where: { $0.prefix == fullCountryCode })
        
        return country
    }
}
