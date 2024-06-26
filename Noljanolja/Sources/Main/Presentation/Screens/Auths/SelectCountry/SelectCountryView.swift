//
//  SelectCountryView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 25/02/2023.
//
//

import SwiftUI
import SwiftUIX

// MARK: - SelectCountryView

struct SelectCountryView<ViewModel: SelectCountryViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    // MARK: State

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        buildContentView()
            .navigationBar(title: L10n.countriesTitle, isPresent: true, backButtonTitle: "", presentationMode: presentationMode, trailing: {})
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
    }

    private func buildContentView() -> some View {
        VStack(spacing: 8) {
            buildSearchView()
            buildCountriesView()
        }
    }

    private func buildSearchView() -> some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 16, height: 16)
                .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
            TextField(L10n.commonSearch, text: $viewModel.searchString)
                .textFieldStyle(TappableTextFieldStyle())
                .frame(maxHeight: .infinity)
                .dynamicFont(.systemFont(ofSize: 16))
            if !viewModel.searchString.isEmpty {
                Button(
                    action: {
                        viewModel.searchString = ""
                    },
                    label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
                    }
                )
            }
        }
        .padding(.leading, 12)
        .padding(.trailing, 8)
        .height(Constant.SearchBar.height)
        .background(ColorAssets.neutralLightGrey.swiftUIColor)
        .cornerRadius(12)
        .padding(.horizontal, 16)
        .padding(.trailing, 8)
    }

    private func buildCountriesView() -> some View {
        ListView {
            ForEach(viewModel.countries.indices, id: \.self) { index in
                let country = viewModel.countries[index]
                Button(
                    action: {
                        viewModel.selectedCountry = country
                        presentationMode.wrappedValue.dismiss()
                    },
                    label: {
                        VStack(spacing: 0) {
                            Text(country.name)
                                .dynamicFont(.systemFont(ofSize: 16))
                                .frame(height: 52)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Divider()
                                .frame(height: 1)
                                .overlay(ColorAssets.neutralLightGrey.swiftUIColor)
                        }
                        .padding(.horizontal, 16)
                    }
                )
                .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
                .background(
                    viewModel.selectedCountry == country
                        ? ColorAssets.neutralLightGrey.swiftUIColor
                        : Color.clear
                )
            }
        }
    }
}

// MARK: - SelectCountryView_Previews

struct SelectCountryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SelectCountryView(
                viewModel: SelectCountryViewModel(
                    selectedCountry: CountryNetworkRepositoryImpl().getDefaultCountry()
                )
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
