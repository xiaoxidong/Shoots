import SwiftUI

@available(iOS 13.0, macOS 10.15, *)
public struct RangeSlider: View {
    @Environment(\.rangeSliderStyle) private var style
    @State private var dragOffset: CGFloat?
    
    private var configuration: RangeSliderStyleConfiguration
    
    public var body: some View {
        self.style.makeBody(
            configuration: self.configuration.with(
                dragOffset: self.$dragOffset
            )
        )
    }
}

@available(iOS 13.0, macOS 10.15, *)
extension RangeSlider {
    init(_ configuration: RangeSliderStyleConfiguration) {
        self.configuration = configuration
    }
}

@available(iOS 13.0, macOS 10.15, *)
extension RangeSlider {
    public init<V>(
        value: Binding<V>,
        lowerBound: Binding<V>,
        upperBound: Binding<V>,
        in bounds: ClosedRange<V> = 0.0...1.0,
        step: V.Stride = 0.001,
        distance: ClosedRange<V> = 0.0 ... .infinity,
        onEditingChanged: @escaping (Bool) -> Void = { _ in }
    ) where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint {
        self.init(
            RangeSliderStyleConfiguration(
                value: Binding(get: { CGFloat(value.wrappedValue.clamped(to: bounds)) }, set: { value.wrappedValue = V($0) }),
                range: Binding(
                    get: { CGFloat(lowerBound.wrappedValue.clamped(to: bounds)) ... CGFloat(upperBound.wrappedValue.clamped(to: bounds)) },
                    set: {
                        lowerBound.wrappedValue = V($0.lowerBound)
                        upperBound.wrappedValue = V($0.upperBound)
                    }
                ),
                bounds: CGFloat(bounds.lowerBound) ... CGFloat(bounds.upperBound),
                step: CGFloat(step),
                distance: CGFloat(distance.lowerBound) ... CGFloat(distance.upperBound),
                onEditingChanged: onEditingChanged,
                dragOffset: .constant(0)
            )
        )
    }
}

@available(iOS 13.0, macOS 10.15, *)
extension RangeSlider {
    public init<V>(
        value: Binding<V>,
        range: Binding<ClosedRange<V>>,
        in bounds: ClosedRange<V> = 0...1,
        step: V.Stride = 1,
        distance: ClosedRange<V> = 0 ... .max,
        onEditingChanged: @escaping (Bool) -> Void = { _ in }
    ) where V : FixedWidthInteger, V.Stride : FixedWidthInteger {
        self.init(
            RangeSliderStyleConfiguration(
                value: Binding(get: { CGFloat(value.wrappedValue.clamped(to: bounds)) }, set: { value.wrappedValue = V($0) }),
                range: Binding(
                    get: { CGFloat(range.wrappedValue.lowerBound) ... CGFloat(range.wrappedValue.upperBound) },
                    set: { range.wrappedValue = V($0.lowerBound) ... V($0.upperBound) }
                ),
                bounds: CGFloat(bounds.lowerBound) ... CGFloat(bounds.upperBound),
                step: CGFloat(step),
                distance: CGFloat(distance.lowerBound) ... CGFloat(distance.upperBound),
                onEditingChanged: onEditingChanged,
                dragOffset: .constant(0)
            )
        )
    }
}
