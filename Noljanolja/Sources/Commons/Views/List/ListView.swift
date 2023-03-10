//
//  List.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/03/2023.
//

import SwiftUI

// MARK: - ListView

struct ListView<Content: View>: View {
    var content: () -> Content

    var body: some View {
        if #available(iOS 15.0, *) {
            List {
                content()
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
            .listSectionSeparator(.hidden)
        } else {
            ScrollView {
                LazyVStack {
                    content()
                }
            }
        }
    }
}

extension ListView {}

// MARK: - ListView_Previews

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView {
            ForEach(0...10, id: \.self) {
                Text("Text \($0)")
            }
        }
    }
}
