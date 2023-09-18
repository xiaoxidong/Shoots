import SwiftUI

@available(iOS 13.0, macOS 10.15, *)
public struct AnyRangeSliderStyle: RangeSliderStyle {
    private let styleMakeBody: (RangeSliderStyle.Configuration) -> AnyView
    
    public init<S: RangeSliderStyle>(_ style: S) {
        self.styleMakeBody = style.makeTypeErasedBody
    }
    
    public func makeBody(configuration: RangeSliderStyle.Configuration) -> AnyView {
        self.styleMakeBody(configuration)
    }
}

@available(iOS 13.0, macOS 10.15, *)
fileprivate extension RangeSliderStyle {
    func makeTypeErasedBody(configuration: RangeSliderStyle.Configuration) -> AnyView {
        AnyView(makeBody(configuration: configuration))
    }
}
