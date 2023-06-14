//
//  ShootColorScheme.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/24.
//

import SwiftUI

enum ShootColorScheme: String, Codable {
    case light
    case dark
    case none
    
    var colorScheme: ColorScheme? {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        case .none:
            return .none
        }
    }
    
    func colorScheme(_ colorScheme: ColorScheme) -> ColorScheme {
        if self == .light {
            return .light
        } else if self == .dark {
            return .dark
        } else {
            if colorScheme == .dark {
                return .dark
            } else {
                return .light
            }
        }
    }
    
    #if os(iOS)
    func system(_ systemStyle: Bool) -> UIStatusBarStyle {
        if systemStyle {
            return systemStatusStyle
        } else {
            return antiSystemStatusStyle
        }
    }
    var systemStatusStyle: UIStatusBarStyle {
        switch self {
        case .light:
            return .darkContent
        case .dark:
            return .lightContent
        case .none:
            return .darkContent
        }
    }
    
    var antiSystemStatusStyle: UIStatusBarStyle {
        switch self {
        case .light:
            return .lightContent
        case .dark:
            return .darkContent
        case .none:
            return .lightContent
        }
    }
    #endif
}
