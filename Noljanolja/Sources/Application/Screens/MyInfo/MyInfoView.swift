//
//  MyInfoView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/02/2023.
//
//

import SwiftUI

// MARK: - MyInfoView

struct MyInfoView<ViewModel: MyInfoViewModelType>: View {
    // MARK: Dependencies

    @StateObject private var viewModel: ViewModel

    // MARK: State

    init(viewModel: ViewModel = MyInfoViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Text("noljanolja")
                    .font(FontFamily.NotoSans.bold.swiftUIFont(size: 18))
                    .frame(height: 82)
                Divider()
                    .background(ColorAssets.forcegroundTertiary.swiftUIColor)

                MyInfoItemView(title: L10n.MyInfo.editMemberInformation)
                MyInfoItemView(title: L10n.MyInfo.changePassword)
                MyInfoItemView(title: L10n.MyInfo.exchangeAccountManagement)
                MyInfoItemView(title: L10n.MyInfo.setting)
                Button(
                    action: { viewModel.signOutTrigger.send() },
                    label: {
                        MyInfoItemView(
                            title: L10n.MyInfo.logOut,
                            hasArrowImage: false
                        )
                    }
                )
            }
            .padding(16)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(L10n.myInfo)
                    .font(FontFamily.NotoSans.bold.swiftUIFont(size: 18))
            }
        }
    }
}

// MARK: - MyInfoView_Previews

struct MyInfoView_Previews: PreviewProvider {
    static var previews: some View {
        MyInfoView()
    }
}
