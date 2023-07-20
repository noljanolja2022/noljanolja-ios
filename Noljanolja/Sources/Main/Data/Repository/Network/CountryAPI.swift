//
//  CountryAPI.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 04/04/2023.
//

import Combine
import Foundation
import PhoneNumberKit

// MARK: - CountryAPIType

protocol CountryAPIType {
    func getDefaultCountry() -> Country
    func getCountries() -> AnyPublisher<[Country], Error>
}

// MARK: - CountryAPI

final class CountryAPI: CountryAPIType {
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
}
