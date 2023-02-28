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

    init(viewModel: ViewModel = SelectCountryViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                HStack(spacing: 8) {
                    TextField("Search country", text: $viewModel.searchText)
                        .keyboardType(.phonePad)
                        .textFieldStyle(FullSizeTappableTextFieldStyle())
                        .frame(height: 32)
                        .font(FontFamily.NotoSans.medium.swiftUIFont(size: 16))
                    if !viewModel.searchText.isEmpty {
                        Button(
                            action: {
                                viewModel.searchText = ""
                            },
                            label: {
                                Image(systemName: "xmark.circle.fill")
                                    .resizable()
                                    .frame(width: 24, height: 24)
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

                Button(L10n.Common.close) {
                    presentationMode.wrappedValue.dismiss()
                }
                .font(FontFamily.NotoSans.bold.swiftUIFont(size: 16))
                .foregroundColor(ColorAssets.forcegroundPrimary.swiftUIColor)
                .padding(.horizontal, 4)
            }
            .padding(.horizontal, 16)

            Divider()
                .padding(.top, 12)

            List {
                ForEach(viewModel.countries) { country in
                    Button(
                        action: {
                            viewModel.selectCountryTrigger.send(country)
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
                        viewModel.selectCountryTrigger.value == country
                            ? ColorAssets.gray.swiftUIColor
                            : Color.clear
                    )
                }
                .listRowInsets(EdgeInsets())
            }
            .padding(.horizontal, 16)
            .listStyle(.plain)
        }
    }
}

// MARK: - SelectCountryView_Previews

struct SelectCountryView_Previews: PreviewProvider {
    static var previews: some View {
        SelectCountryView()
    }
}
