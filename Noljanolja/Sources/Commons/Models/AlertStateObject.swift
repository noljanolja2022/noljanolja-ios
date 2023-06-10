//
//  AlertStateObject.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/06/2023.
//

import _SwiftUINavigationState
import Foundation

final class AlertStateObject<Action>: ObservableObject {
    @Published var alertState: AlertState<Action>?
}
