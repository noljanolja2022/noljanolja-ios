//
//  String+Encode.swift
//  Noljanolja
//
//  Created by duydinhv on 10/11/2023.
//

import Foundation

extension String {
    func stringEncode() -> String {
        let encodedURLString = addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return encodedURLString
    }
}
