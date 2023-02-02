//
//  TabItem.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 02/02/2023.
//

import SwiftUI

struct TabItem: View {
    private let systemName: String

    init(systemName: String) {
        self.systemName = systemName
    }

    var body: some View {
        Image(systemName: systemName)
    }
}
