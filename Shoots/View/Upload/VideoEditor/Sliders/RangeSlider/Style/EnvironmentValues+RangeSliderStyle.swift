import SwiftUI

@available(iOS 13.0, macOS 10.15, *)
public extension EnvironmentValues {
    var rangeSliderStyle: AnyRangeSliderStyle {
        get {
            return self[RangeSliderStyleKey.self]
        }
        set {
            self[RangeSliderStyleKey.self] = newValue
        }
    }
}

@available(iOS 13.0, macOS 10.15, *)
struct RangeSliderStyleKey: EnvironmentKey {
    static let defaultValue: AnyRangeSliderStyle = AnyRangeSliderStyle(
        HorizontalRangeSliderStyle()
    )
}

@available(iOS 13.0, macOS 10.15, *)
public extension View {
    /// Sets the style for `RangeSlider` within the environment of `self`.
    @inlinable func rangeSliderStyle<S>(_ style: S) -> some View where S : RangeSliderStyle {
        self.environment(\.rangeSliderStyle, AnyRangeSliderStyle(style))
    }
}
