//
//  UIScreen.swift
//  Noljanolja
//
//  Created by Duy Dinh on 23/11/2023.
//

import UIKit

let ratioW = UIScreen.isPad ? 1.3 : Ratio.widthIPhone6
let ratioH = Ratio.heightIPhoneX

// MARK: - Ratio

public enum Ratio {
    public static let widthIPhone5 = UIScreen.mainWidth / UIScreen.widthIphone5
    public static let widthIPhone6 = UIScreen.mainWidth / UIScreen.widthIphone6
    public static let widthIPhone6P = UIScreen.mainWidth / UIScreen.widthIphone6P
    public static let widthIPadMini = UIScreen.mainWidth / UIScreen.widthIpadMini

    public static let heightIPhone5 = UIScreen.mainHeight / UIScreen.heightIphone5
    public static let heightIPhone6 = UIScreen.mainHeight / UIScreen.heightIphone6
    public static let heightIPhone6P = UIScreen.mainHeight / UIScreen.heightIphone6P
    public static let heightIPhoneX = UIScreen.mainHeight / UIScreen.heightIphoneX
}

// MARK: - UIScreen

public extension UIScreen {
    static var mainWidth: CGFloat {
        UIScreen.main.bounds.width
    }

    static var mainHeight: CGFloat {
        UIScreen.main.bounds.height
    }

    static var statusBarHeight: CGFloat {
        if let statusBarManager = UIApplication.shared.windows.first?.windowScene?.statusBarManager {
            return statusBarManager.statusBarFrame.size.height
        }
        return 0
    }

    static var statusBarWidth: CGFloat {
        if let statusBarManager = UIApplication.shared.windows.first?.windowScene?.statusBarManager {
            return statusBarManager.statusBarFrame.size.width
        }
        return 0
    }

    static var widthIphone5: CGFloat {
        320
    }

    /// Get the screen width iPhone 6
    static var widthIphone6: CGFloat {
        375
    }

    /// Get the screen width iPhone 6 plus
    static var widthIphone6P: CGFloat {
        414
    }

    /// Get the screen width iPad Mini
    static var widthIpadMini: CGFloat {
        768
    }

    /// Get the screen height iPhone 5
    static var heightIphone5: CGFloat {
        568
    }

    /// Get the screen height iPhone 6
    static var heightIphone6: CGFloat {
        667
    }

    /// Get the screen height iPhone 6 plus
    static var heightIphone6P: CGFloat {
        736
    }

    /// Get the screen height iPhone X
    static var heightIphoneX: CGFloat {
        812
    }

    static var isPhone5: Bool {
        UIDevice.current.userInterfaceIdiom == .phone &&
            UIScreen.mainHeight == UIScreen.heightIphone5
    }

    static var isPhone6: Bool {
        UIDevice.current.userInterfaceIdiom == .phone &&
            UIScreen.mainHeight == UIScreen.heightIphone6
    }

    static var isPhone6P: Bool {
        UIDevice.current.userInterfaceIdiom == .phone &&
            UIScreen.mainHeight == UIScreen.heightIphone6P
    }

    static var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad &&
            UIScreen.mainHeight > UIScreen.heightIphone6P
    }

    static var hasSafeArea: Bool {
        UIScreen.main.bounds.height >= 812
    }

    static var hasTopNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }

    internal static func setBrightness(to value: CGFloat, duration: TimeInterval = 0.3, ticksPerSecond: Double = 120) {
        let startingBrightness = UIScreen.main.brightness
        let delta = value - startingBrightness
        let totalTicks = Int(ticksPerSecond * duration)
        let changePerTick = delta / CGFloat(totalTicks)
        let delayBetweenTicks = 1 / ticksPerSecond

        let time = DispatchTime.now()

        for i in 1...totalTicks {
            DispatchQueue.main.asyncAfter(deadline: time + delayBetweenTicks * Double(i)) {
                UIScreen.main.brightness = max(min(startingBrightness + (changePerTick * CGFloat(i)), 1), 0)
            }
        }
    }
}
