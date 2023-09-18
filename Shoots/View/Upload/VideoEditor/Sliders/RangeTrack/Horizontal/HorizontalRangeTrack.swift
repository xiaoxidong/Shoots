import SwiftUI

@available(iOS 13.0, macOS 10.15, *)
public struct HorizontalRangeTrack<ValueView: View, MaskView: View>: View {
    @Environment(\.trackRange) var range
    @Environment(\.rangeTrackConfiguration) var configuration
    let view: ValueView
    let mask: MaskView

    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black
                    .opacity(0.5)
                    .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                    .reverseMask {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .frame(
                                    width: rangeDistance(
                                        overallLength: geometry.size.width,
                                        range: self.range,
                                        bounds: self.configuration.bounds,
                                        lowerStartOffset: self.configuration.lowerLeadingOffset,
                                        lowerEndOffset: self.configuration.lowerTrailingOffset,
                                        upperStartOffset: self.configuration.upperLeadingOffset,
                                        upperEndOffset: self.configuration.upperTrailingOffset
                                    )
                                )
                                .offset(
                                    x: distanceFrom(
                                        value: self.range.lowerBound,
                                        availableDistance: geometry.size.width,
                                        bounds: self.configuration.bounds,
                                        leadingOffset: self.configuration.lowerLeadingOffset,
                                        trailingOffset: self.configuration.lowerTrailingOffset
                                    )
                                )
                        }
                        .frame(width: geometry.size.width, alignment: .leading)
                    }
                self.view
                    .mask(
                        ZStack {
                            self.mask
                                .frame(
                                    width: rangeDistance(
                                        overallLength: geometry.size.width,
                                        range: self.range,
                                        bounds: self.configuration.bounds,
                                        lowerStartOffset: self.configuration.lowerLeadingOffset,
                                        lowerEndOffset: self.configuration.lowerTrailingOffset,
                                        upperStartOffset: self.configuration.upperLeadingOffset,
                                        upperEndOffset: self.configuration.upperTrailingOffset
                                    )
                                )
                                .offset(
                                    x: distanceFrom(
                                        value: self.range.lowerBound,
                                        availableDistance: geometry.size.width,
                                        bounds: self.configuration.bounds,
                                        leadingOffset: self.configuration.lowerLeadingOffset,
                                        trailingOffset: self.configuration.lowerTrailingOffset
                                    )
                                )
                        }
                            .frame(width: geometry.size.width, alignment: .leading)
                    )
            }
        }
    }
}

@available(iOS 13.0, macOS 10.15, *)
extension HorizontalRangeTrack {
    public init(view: ValueView, mask: MaskView) {
        self.view = view
        self.mask = mask
    }
}

@available(iOS 13.0, macOS 10.15, *)
extension HorizontalRangeTrack where ValueView == DefaultHorizontalValueView {
    public init(mask: MaskView) {
        self.init(view: DefaultHorizontalValueView(), mask: mask)
    }
}

@available(iOS 13.0, macOS 10.15, *)
extension HorizontalRangeTrack where MaskView == Capsule {
    public init(view: ValueView) {
        self.init(view: view, mask: Capsule())
    }
}

@available(iOS 13.0, macOS 10.15, *)
extension HorizontalRangeTrack where ValueView == DefaultHorizontalValueView, MaskView == Capsule {
    public init() {
        self.init(view: DefaultHorizontalValueView(), mask: Capsule())
    }
}

@available(iOS 13.0, macOS 10.15, *)
extension View {
    @inlinable
    public func reverseMask<Mask: View>(@ViewBuilder _ mask: () -> Mask) -> some View {
        self.mask (
            Rectangle()
                .overlay(
                    mask()
                        .blendMode(.destinationOut)
                )
        )
    }
}
