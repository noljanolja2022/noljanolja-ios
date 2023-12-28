//
//  AppTheme.swift
//  Noljanolja
//
//  Created by kii on 28/12/2023.
//

import SwiftUI

// MARK: - ThemePrimary

protocol ThemePrimary {
    static var pr50: Color { get }
    static var pr100: Color { get }
    static var pr200: Color { get }
    static var pr300: Color { get }
    static var pr400: Color { get }
}

// MARK: - GreenPrimary

struct GreenPrimary: ThemePrimary {
    static var pr50: Color = ColorAssets.primaryGreen50.swiftUIColor
    static var pr100: Color = ColorAssets.primaryGreen100.swiftUIColor
    static var pr200: Color = ColorAssets.primaryGreen200.swiftUIColor
    static var pr300: Color = ColorAssets.primaryGreen300.swiftUIColor
    static var pr400: Color = ColorAssets.primaryGreen400.swiftUIColor
}

// MARK: - YellowPrimary

struct YellowPrimary: ThemePrimary {
    static var pr50: Color = ColorAssets.primaryYellow50.swiftUIColor
    static var pr100: Color = ColorAssets.primaryYellow100.swiftUIColor
    static var pr200: Color = ColorAssets.primaryYellow200.swiftUIColor
    static var pr300: Color = ColorAssets.primaryYellow300.swiftUIColor
    static var pr400: Color = ColorAssets.primaryYellow400.swiftUIColor
}

// MARK: - BluePrimary

struct BluePrimary: ThemePrimary {
    static var pr50: Color = ColorAssets.primaryBlue50.swiftUIColor
    static var pr100: Color = ColorAssets.primaryBlue100.swiftUIColor
    static var pr200: Color = ColorAssets.primaryBlue200.swiftUIColor
    static var pr300: Color = ColorAssets.primaryBlue300.swiftUIColor
    static var pr400: Color = ColorAssets.primaryBlue400.swiftUIColor
}

// MARK: - AppTheme

enum AppTheme: Int, CaseIterable, Codable {
    case green, blue, yellow

    var primary50: Color {
        switch self {
        case .green:
            return GreenPrimary.pr50
        case .blue:
            return BluePrimary.pr50
        case .yellow:
            return YellowPrimary.pr50
        }
    }

    var primary100: Color {
        switch self {
        case .green:
            return GreenPrimary.pr100
        case .blue:
            return BluePrimary.pr100
        case .yellow:
            return YellowPrimary.pr100
        }
    }

    var primary200: Color {
        switch self {
        case .green:
            return GreenPrimary.pr200
        case .blue:
            return BluePrimary.pr200
        case .yellow:
            return YellowPrimary.pr200
        }
    }

    var primary300: Color {
        switch self {
        case .green:
            return GreenPrimary.pr300
        case .blue:
            return BluePrimary.pr300
        case .yellow:
            return YellowPrimary.pr300
        }
    }

    var primary400: Color {
        switch self {
        case .green:
            return GreenPrimary.pr400
        case .blue:
            return BluePrimary.pr400
        case .yellow:
            return YellowPrimary.pr400
        }
    }

    var title: String {
        switch self {
        case .green:
            return "Default"
        case .blue:
            return "Elegant blue"
        case .yellow:
            return "Warm gold"
        }
    }
}
