//
//  ComingSoonView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 11/10/2023.
//

import SwiftUI

struct ComingSoonView: View {
    var body: some View {
        Text(L10n.comingSoonDescription)
            .dynamicFont(.systemFont(ofSize: 16, weight: .medium))
            .multilineTextAlignment(.center)
            .frame(alignment: .center)
            .padding(16)
    }
}
