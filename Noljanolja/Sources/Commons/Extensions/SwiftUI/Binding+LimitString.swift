//
//  Binding+LimitString.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 25/02/2023.
//

import Foundation
import SwiftUI

extension Binding where Value == String {
    func max(_ limit: Int) -> Self {
        if wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.dropLast())
            }
        }
        return self
    }
}
