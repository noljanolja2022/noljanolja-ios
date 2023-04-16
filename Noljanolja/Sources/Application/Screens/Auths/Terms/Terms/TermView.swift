//
//  TermView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 28/02/2023.
//
//

import SwiftUI
import SwiftUINavigation
import SwiftUIX

// MARK: - TermView

struct TermView<ViewModel: TermViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    // MARK: State

    @State private var selectedTermType: TermItemType?

    var body: some View {
        buildContentView()
            .hideNavigationBar()
            .alert(item: $viewModel.alertState) { Alert($0) { _ in } }
            .fullScreenCover(
                unwrapping: $selectedTermType,
                content: { selectedTermType in
                    TermDetailView(
                        viewModel: TermDetailViewModel(),
                        termType: selectedTermType.wrappedValue
                    )
                }
            )
    }

    private func buildContentView() -> some View {
        VStack(spacing: 0) {
            buildHeaderView()
            VStack(spacing: 0) {
                buildTermItemsView()
                buildActionView()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ColorAssets.white.swiftUIColor)
            .cornerRadius(40, corners: [.topLeft, .topRight])
        }
        .background(ColorAssets.primaryYellowMain.swiftUIColor.ignoresSafeArea(edges: [.top]))
    }

    private func buildHeaderView() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            ImageAssets.logo.swiftUIImage
                .resizable()
                .scaledToFill()
                .frame(width: 66, height: 62)
            Text("Login")
                .font(.system(size: 32, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 12)
            Text("Welcome to Noja Noja. Follow these steps to be our member.")
                .font(.system(size: 14))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
    }

    private func buildTermItemsView() -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                ForEach(TermSectionType.allCases) { sectionType in
                    Text(sectionType.title.uppercased())
                        .frame(alignment: .leading)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                        .padding(.top, 32)

                    ForEach(
                        TermItemType.allCases
                            .filter {
                                $0.sectionType == sectionType
                            }
                            .sorted { $0.rawValue < $1.rawValue }
                    ) { itemType in
                        TermItemView(
                            selected: Binding<Bool>(
                                get: { viewModel.termItemCheckeds[itemType] ?? false },
                                set: {
                                    viewModel.termItemCheckeds[itemType] = $0
                                }
                            ),
                            title: itemType.title,
                            action: { selectedTermType = itemType }
                        )
                    }
                }
            }
            .padding(16)
        }
    }

    private func buildActionView() -> some View {
        Button(
            "NEXT",
            action: { viewModel.actionSubject.send() }
        )
        .buttonStyle(PrimaryButtonStyle(isEnabled: viewModel.isAllTermChecked))
        .disabled(!viewModel.isAllTermChecked)
        .frame(height: 48)
        .padding(16)
    }
}

// MARK: - TermView_Previews

struct TermView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TermView(
                viewModel: TermViewModel()
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
