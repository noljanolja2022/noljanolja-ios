//
//  @Published.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 24/05/2023.
//

import Combine
import Foundation

@propertyWrapper
final class PublishedCurrentValue<Value> {
    private let subject: CurrentValueSubject<Value, Never>

    init(wrappedValue initialValue: Value) {
        self.subject = CurrentValueSubject(initialValue)
    }

    var wrappedValue: Value {
        get {
            subject.value
        }
        set {
            subject.send(newValue)
        }
    }

    var projectedValue: AnyPublisher<Value, Never> {
        subject.eraseToAnyPublisher()
    }
}
