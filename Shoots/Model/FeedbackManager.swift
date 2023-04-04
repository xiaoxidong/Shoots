//
//  FeedbackManager.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/4/3.
//

import SwiftUI
import Foundation

enum FeedbackManager {
    static func mediumFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }
    
    static func haptic(type: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }

    static func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
}
