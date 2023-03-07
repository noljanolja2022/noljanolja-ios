//
//  UIApplication+Extension.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 16/02/2023.
//

import Foundation
import SwiftUI
import UIKit

extension UIApplication {
    var rootKeyWindow: UIWindow? {
        if #available(iOS 15, *) {
            return UIApplication
                .shared
                .connectedScenes
                .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                .first { $0.isKeyWindow }
        } else {
            return UIApplication
                .shared
                .connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }
        }
    }

    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension View {
    func endEditing() {
        UIApplication.shared.endEditing()
    }
}
