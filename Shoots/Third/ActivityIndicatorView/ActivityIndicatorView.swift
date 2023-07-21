//
//  ActivityIndicatorView.swift
//  ActivityIndicatorView
//
//  Created by Alisa Mylnikova on 20/03/2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

public struct ActivityIndicatorView: View {
    public enum IndicatorType {
        case `default`
        case arcs
        case rotatingDots
        case flickeringDots
        case scalingDots
        case opacityDots
        case equalizer
        case growingArc(Color = .red)
        case growingCircle
        case gradient([Color], CGLineCap = .butt)
    }

    @Binding var isVisible: Bool
    var type: IndicatorType
    var text: String = "加载中..."
    var width: CGFloat = 36
    public init(isVisible: Binding<Bool>, type: IndicatorType, text: String = "加载中...", width: CGFloat = 36) {
        _isVisible = isVisible
        self.type = type
        self.width = width
        self.text = text
    }

    public var body: some View {
        guard isVisible else { return AnyView(EmptyView()) }
        switch type {
        case .default:
            return AnyView(DefaultIndicatorView())
        case .arcs:
            return AnyView(
                Group {
                    if text == "" {
                        ArcsIndicatorView()
                            .frame(width: width, height: width)
                            .padding(8)
                    } else {
                        HStack(spacing: -6) {
                            ArcsIndicatorView()
                                .frame(width: width, height: width)
                            Text(LocalizedStringKey(text))
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color.shootWhite)
                                .fixedSize()
                        }
                        .padding(.vertical, 8)
                        .padding(.leading, 14)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 6)
                    }
                }
            )
        case .rotatingDots:
            return AnyView(RotatingDotsIndicatorView())
        case .flickeringDots:
            return AnyView(FlickeringDotsIndicatorView())
        case .scalingDots:
            return AnyView(ScalingDotsIndicatorView())
        case .opacityDots:
            return AnyView(OpacityDotsIndicatorView())
        case .equalizer:
            return AnyView(EqualizerIndicatorView())
        case let .growingArc(color):
            return AnyView(GrowingArcIndicatorView(color: color))
        case .growingCircle:
            return AnyView(GrowingCircleIndicatorView())
        case let .gradient(colors, lineCap):
            return AnyView(GradientIndicatorView(colors: colors, lineCap: lineCap))
        }
    }
}
