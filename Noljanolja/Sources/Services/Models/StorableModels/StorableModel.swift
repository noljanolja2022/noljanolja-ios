//
//  StorableObject.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//

import Foundation

protocol StorableModel {
    associatedtype Model

    var model: Model? { get }

    init(_ model: Model)
}
