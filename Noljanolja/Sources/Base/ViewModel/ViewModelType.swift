//
//  ViewModelType.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 03/03/2023.
//

import Combine
import Foundation

// MARK: - ViewModel

public class ViewModel: NSObject, ObservableObject {
    public let isAppearSubject = CurrentValueSubject<Bool, Never>(false)
}
