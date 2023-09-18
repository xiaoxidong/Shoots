//
//  Shake Modifier.swift
//  Items
//
//  Created by Ian on 27/03/2022.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, *)
struct Shake: GeometryEffect {
    var amount: CGFloat = 5
    var shakesPerUnit: CGFloat = 5
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        let xTranslation = amount * sin(animatableData * .pi * shakesPerUnit)
        let transform = CGAffineTransform(translationX: xTranslation, y: 0)
        return ProjectionTransform(transform)
    }
}
