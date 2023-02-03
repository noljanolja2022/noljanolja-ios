//
//  TabItem.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 02/02/2023.
//

import SwiftUI

struct TabItem {
    let image: String
    let offset: CGSize
    let backgroundColor: Color

    init(image: String, offset: CGSize = .zero, backgroundColor: Color = .clear) {
        self.image = image
        self.offset = offset
        self.backgroundColor = backgroundColor
    }
}
