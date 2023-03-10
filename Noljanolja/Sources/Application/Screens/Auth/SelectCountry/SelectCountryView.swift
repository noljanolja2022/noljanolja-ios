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
                    .foregroundColor(ColorAssets.forcegroundPrimary.swiftUIColor)
                }
                ToolbarItem(placement: .principal) {
                    Text("Select country")
                        .font(FontFamily.NotoSans.bold.swiftUIFont(size: 18))
                        .foregroundColor(ColorAssets.forcegroundPrimary.swiftUIColor)
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
                    .foregroundColor(ColorAssets.forcegroundPrimary.swiftUIColor)
                TextField("Search", text: $viewModel.state.searchString)
                    .keyboardType(.phonePad)
                    .textFieldStyle(FullSizeTappableTextFieldStyle())
                    .frame(height: 32)
                    .font(FontFamily.NotoSans.medium.swiftUIFont(size: 16))
                if !viewModel.state.searchString.isEmpty {
                    Button(
                        action: {
                            viewModel.state.searchString = ""
                        },
                        label: {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(ColorAssets.forcegroundPrimary.swiftUIColor)
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
                            .font(FontFamily.NotoSans.medium.swiftUIFont(size: 16))
                            .frame(height: 52)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                )
                .background(
                    viewModel.state.selectedCountry == country
                        ? ColorAssets.gray.swiftUIColor
                        : Color.clear
                )
            }
            .listRowInsets(EdgeInsets())
        }
        .listStyle(.plain)
        .padding(.horizontal, 16)
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
