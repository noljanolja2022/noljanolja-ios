////
////  StateView.swift
////  Noljanolja
////
////  Created by Nguyen The Trinh on 27/02/2023.
////
//
// import SwiftUI
//
//// MARK: - StateView
//
// struct StateView<Content: View>: View {
//    var title: String?
//    var description: String?
//    var actions: () -> Content
//
//    var body: some View {
//        ZStack {
//            VStack(alignment: .center, spacing: 16) {
//                if let title, !title.isEmpty {
//                    Text(title)
//                        .multilineTextAlignment(.center)
//                        .dynamicFont(FontFamily.NotoSans.bold.swiftUIFont(size: 18))
//                }
//                if let description, !description.isEmpty {
//                    Text(description)
//                        .multilineTextAlignment(.center)
//                        .dynamicFont(FontFamily.NotoSans.medium.swiftUIFont(size: 16))
//                }
//
//                actions()
//            }
//            .padding(16)
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//    }
// }
//
//// MARK: - StateView_Previews
//
// struct StateView_Previews: PreviewProvider {
//    static var previews: some View {
//        StateView(
//            title: "Title",
//            description: "Description Description Description Description Description Description Description Description",
//            actions: { EmptyView() }
//        )
//    }
// }
