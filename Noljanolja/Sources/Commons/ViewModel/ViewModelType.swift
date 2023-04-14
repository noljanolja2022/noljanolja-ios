//
//  ViewModelType.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 03/03/2023.
//

import Combine
import Foundation

// MARK: - ViewModelType

public protocol ViewModelType<State, Action>: ObservableObject {
    associatedtype State
    associatedtype Action

    var state: State { get set }

    func send(_ action: Action)
}

// MARK: - ViewModel

public class ViewModel: ObservableObject {
    public let isAppearSubject = CurrentValueSubject<Bool, Never>(false)
}
