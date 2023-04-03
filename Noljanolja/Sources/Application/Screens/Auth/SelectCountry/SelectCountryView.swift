//
//  SelectCountryView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 25/02/2023.
//
//

import SwiftUI

// MARK: - SelectCountryView

struct SelectCountryView<ViewModel: SelectCountryViewModelType>: View {
    // MARK: Dependencies

    @StateObject private var viewModel: ViewModel

    // MARK: State

    @Environment(\.presentationMode) private var presentationMode

    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        buildContentView()
            .onAppear { viewModel.send(.loadData) }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(
                        action: { presentationMode.wrappedValue.dismiss() },
                        label: {
                            Image(systemName: "xmark")
                        }
                    )
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
                ToolbarItem(placement: .principal) {
                    Text("Select country")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
            }
    }

    private func buildContentView() -> some View {
        VStack(spacing: 0) {
            buildSearchView()
            buildCountriesView()
        }
    }

    private func buildSearchView() -> some View {
        HStack(spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 22, height: 22)
                    .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
                TextField("Search", text: $viewModel.state.searchString)
                    .keyboardType(.phonePad)
                    .textFieldStyle(TappableTextFieldStyle())
                    .frame(height: 32)
                    .font(.system(size: 16))
                if !viewModel.state.searchString.isEmpty {
                    Button(
                        action: {
                            viewModel.state.searchString = ""
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
            .frame(height: 44)
            .background(ColorAssets.gray.swiftUIColor)
            .cornerRadius(12)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }

    private func buildCountriesView() -> some View {
        ListView {
            ForEach(viewModel.state.countries) { country in
                Button(
                    action: {
                        viewModel.send(.selectCountry(country))
                        presentationMode.wrappedValue.dismiss()
                    },
                    label: {
                        Text(country.name)
                            .font(.system(size: 16))
                            .frame(height: 52)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                    }
                )
                .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
                .background(
                    viewModel.state.selectedCountry == country
                        ? ColorAssets.neutralLightGrey.swiftUIColor
                        : Color.clear
                )
            }
            .listRowInsets(EdgeInsets())
        }
        .listStyle(.plain)
    }
}

// MARK: - SelectCountryView_Previews

struct SelectCountryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SelectCountryView(
                viewModel: SelectCountryViewModel(
                    state: SelectCountryViewModel.State(selectedCountry: .default)
                )
            )
        }
    }
}
