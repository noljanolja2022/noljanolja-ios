//
//  Constant.swift
//  Noljanolja
//
//  Created by Duy Dinh on 28/12/2023.
//

import Foundation
import UIKit

let kUserDefault = UserDefaults.standard
let kMainThread = DispatchQueue.main
let kScreen = UIScreen.main
let kDevice = UIDevice.current
let kScreenSize = CGSize(width: kScreen.bounds.width, height: kScreen.bounds.height)

// MARK: - Constant

enum Constant {
    enum NavigationBar {
        static var height: CGFloat {
            42
        }
    }

    enum SearchBar {
        static var height: CGFloat {
            36
        }
    }
}
