//
//  Binding+LimitString.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 25/02/2023.
//

import Foundation
import SwiftUI

extension Binding where Value == String {
    func max(_ length: Int) -> Self {
        if wrappedValue.count > length {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(length))
            }
        }
        return self
    }
}

extension Binding where Value == String? {
    func max(_ length: Int) -> Self {
        if wrappedValue?.count ?? 0 > length {
            DispatchQueue.main.async {
                self.wrappedValue = (self.wrappedValue?.prefix(length)).flatMap { String($0) }
            }
        }
        return self
    }
}
