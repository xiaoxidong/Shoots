import SwiftUI

@available(iOS 13.0, macOS 10.15, *)
public struct HorizontalRangeSliderStyle<Track: View, Thumb: View, ThumbOverlay: View, LowerThumb: View, UpperThumb: View>: RangeSliderStyle {
    private let track: Track
    private let thumb: Thumb
    private let thumbOverlay: ThumbOverlay
    private let lowerThumb: LowerThumb
    private let upperThumb: UpperThumb

    let thumbSize: CGSize
    let lowerThumbSize: CGSize
    let upperThumbSize: CGSize

    let thumbInteractiveSize: CGSize
    let lowerThumbInteractiveSize: CGSize
    let upperThumbInteractiveSize: CGSize

    private let options: RangeSliderOptions

    public func makeBody(configuration: Self.Configuration) -> some View {
        GeometryReader { geometry in
            ZStack {
                self.track
                    .environment(\.trackRange, configuration.range.wrappedValue)
                    .environment(\.rangeTrackConfiguration, RangeTrackConfiguration(
                        bounds: configuration.bounds,
                        lowerLeadingOffset: self.lowerThumbSize.width / 2,
                        lowerTrailingOffset: self.lowerThumbSize.width / 2 + self.upperThumbSize.width,
                        upperLeadingOffset: self.lowerThumbSize.width + self.upperThumbSize.width / 2,
                        upperTrailingOffset: self.upperThumbSize.width / 2
                    ))
                    .accentColor(Color.accentColor)

                self.thumbOverlay
                    .position(
                        x: distanceFrom(
                            value: configuration.value.wrappedValue,
                            availableDistance: geometry.size.width,
                            bounds: configuration.bounds,
                            leadingOffset: self.lowerThumbSize.width + self.thumbSize.width / 2,
                            trailingOffset: self.upperThumbSize.width + self.thumbSize.width / 2
                        ),
                        y: -(geometry.size.height / 2)
                    )

                ZStack {
                    self.lowerThumb
                        .frame(width: self.lowerThumbSize.width, height: self.lowerThumbSize.height)
                }
                .frame(minWidth: self.lowerThumbInteractiveSize.width, minHeight: self.lowerThumbInteractiveSize.height)
                .position(
                    x: distanceFrom(
                        value: configuration.range.wrappedValue.lowerBound,
                        availableDistance: geometry.size.width,
                        bounds: configuration.bounds,
                        leadingOffset: self.lowerThumbSize.width / 2,
                        trailingOffset: self.upperThumbSize.width + self.thumbSize.width + self.lowerThumbSize.width / 2
                    ),
                    y: geometry.size.height / 2
                )
                .gesture(
                    DragGesture()
                        .onChanged { gestureValue in
                            configuration.onEditingChanged(true)

                            if configuration.dragOffset.wrappedValue == nil {
                                configuration.dragOffset.wrappedValue = gestureValue.startLocation.x - distanceFrom(
                                    value: configuration.range.wrappedValue.lowerBound,
                                    availableDistance: geometry.size.width - self.upperThumbSize.width - self.thumbSize.width,
                                    bounds: configuration.bounds,
                                    leadingOffset: self.lowerThumbSize.width / 2,
                                    trailingOffset: self.lowerThumbSize.width / 2
                                )
                            }

                            let computedLowerBound = valueFrom(
                                distance: gestureValue.location.x - (configuration.dragOffset.wrappedValue ?? 0),
                                availableDistance: geometry.size.width - self.upperThumbSize.width - self.thumbSize.width,
                                bounds: configuration.bounds,
                                step: configuration.step,
                                leadingOffset: self.lowerThumbSize.width / 2,
                                trailingOffset: self.lowerThumbSize.width / 2
                            )

                            configuration.range.wrappedValue = rangeFrom(
                                updatedLowerBound: computedLowerBound,
                                upperBound: configuration.range.wrappedValue.upperBound,
                                bounds: configuration.bounds,
                                distance: configuration.distance,
                                forceAdjacent: options.contains(.forceAdjacentValue)
                            )

                            configuration.value.wrappedValue = configuration.range.wrappedValue.lowerBound
                        }
                        .onEnded { _ in
                            configuration.dragOffset.wrappedValue = nil
                            configuration.onEditingChanged(false)
                        }
                )

                ZStack {
                    self.upperThumb
                        .frame(width: self.upperThumbSize.width, height: self.upperThumbSize.height)
                }
                .frame(minWidth: self.upperThumbInteractiveSize.width, minHeight: self.upperThumbInteractiveSize.height)
                .position(
                    x: distanceFrom(
                        value: configuration.range.wrappedValue.upperBound,
                        availableDistance: geometry.size.width,
                        bounds: configuration.bounds,
                        leadingOffset: self.lowerThumbSize.width + self.thumbSize.width + self.upperThumbSize.width / 2,
                        trailingOffset: self.upperThumbSize.width / 2
                    ),
                    y: geometry.size.height / 2
                )
                .gesture(
                    DragGesture()
                        .onChanged { gestureValue in
                            configuration.onEditingChanged(true)

                            if configuration.dragOffset.wrappedValue == nil {
                                configuration.dragOffset.wrappedValue = gestureValue.startLocation.x - distanceFrom(
                                    value: configuration.range.wrappedValue.upperBound,
                                    availableDistance: geometry.size.width - self.thumbSize.width,
                                    bounds: configuration.bounds,
                                    leadingOffset: self.lowerThumbSize.width + self.upperThumbSize.width / 2,
                                    trailingOffset: self.upperThumbSize.width / 2
                                )
                            }

                            let computedUpperBound = valueFrom(
                                distance: gestureValue.location.x - (configuration.dragOffset.wrappedValue ?? 0),
                                availableDistance: geometry.size.width - self.thumbSize.width,
                                bounds: configuration.bounds,
                                step: configuration.step,
                                leadingOffset: self.lowerThumbSize.width + self.upperThumbSize.width / 2,
                                trailingOffset: self.upperThumbSize.width / 2
                            )

                            configuration.range.wrappedValue = rangeFrom(
                                lowerBound: configuration.range.wrappedValue.lowerBound,
                                updatedUpperBound: computedUpperBound,
                                bounds: configuration.bounds,
                                distance: configuration.distance,
                                forceAdjacent: options.contains(.forceAdjacentValue)
                            )
                            configuration.value.wrappedValue = configuration.range.wrappedValue.upperBound
                        }
                        .onEnded { _ in
                            configuration.dragOffset.wrappedValue = nil
                            configuration.onEditingChanged(false)
                        }
                )

                ZStack {
                    self.thumb
                        .frame(width: self.thumbSize.width, height: self.thumbSize.height)
                }
                .frame(minWidth: self.thumbInteractiveSize.width, minHeight: self.thumbInteractiveSize.height)
                .position(
                    x: distanceFrom(
                        value: configuration.value.wrappedValue,
                        availableDistance: geometry.size.width,
                        bounds: configuration.bounds,
                        leadingOffset: self.lowerThumbSize.width + self.thumbSize.width / 2,
                        trailingOffset: self.upperThumbSize.width + self.thumbSize.width / 2
                    ),
                    y: geometry.size.height / 2
                )
                .gesture(
                    DragGesture()
                        .onChanged { gestureValue in
                            configuration.onEditingChanged(true)

                            if configuration.dragOffset.wrappedValue == nil {
                                configuration.dragOffset.wrappedValue = gestureValue.startLocation.x - distanceFrom(
                                    value: configuration.value.wrappedValue,
                                    availableDistance: geometry.size.width - self.lowerThumbSize.width - self.upperThumbSize.width,
                                    bounds: configuration.bounds,
                                    leadingOffset: self.lowerThumbSize.width + self.thumbSize.width / 2,
                                    trailingOffset: self.upperThumbSize.width + self.thumbSize.width / 2
                                )
                            }

                            let computedValue = valueFrom(
                                distance: gestureValue.location.x - (configuration.dragOffset.wrappedValue ?? 0),
                                availableDistance: geometry.size.width - self.lowerThumbSize.width - self.upperThumbSize.width,
                                bounds: configuration.bounds,
                                step: configuration.step,
                                leadingOffset: self.lowerThumbSize.width + self.thumbSize.width / 2,
                                trailingOffset: self.upperThumbSize.width + self.thumbSize.width / 2
                            )
                            if computedValue > configuration.range.wrappedValue.lowerBound && computedValue < configuration.range.wrappedValue.upperBound {
                                configuration.value.wrappedValue = computedValue
                            }

                        }
                        .onEnded { _ in
                            configuration.dragOffset.wrappedValue = nil
                            configuration.onEditingChanged(false)
                        }
                )

            }
            .frame(height: geometry.size.height)
        }
        .frame(minHeight: max(self.lowerThumbInteractiveSize.height, self.upperThumbInteractiveSize.height))
    }

    public init(track: Track, thumb: Thumb, lowerThumb: LowerThumb, upperThumb: UpperThumb, thumbOverlay: ThumbOverlay, thumbSize: CGSize = CGSize(width: 27, height: 27), lowerThumbSize: CGSize = CGSize(width: 27, height: 27), upperThumbSize: CGSize = CGSize(width: 27, height: 27), thumbInteractiveSize: CGSize = CGSize(width: 44, height: 44), lowerThumbInteractiveSize: CGSize = CGSize(width: 44, height: 44), upperThumbInteractiveSize: CGSize = CGSize(width: 44, height: 44), options: RangeSliderOptions = .defaultOptions) {
        self.track = track
        self.thumb = thumb
        self.lowerThumb = lowerThumb
        self.upperThumb = upperThumb
        self.thumbOverlay = thumbOverlay
        self.thumbSize = thumbSize
        self.lowerThumbSize = lowerThumbSize
        self.upperThumbSize = upperThumbSize
        self.thumbInteractiveSize = thumbInteractiveSize
        self.lowerThumbInteractiveSize = lowerThumbInteractiveSize
        self.upperThumbInteractiveSize = upperThumbInteractiveSize
        self.options = options
    }
}

@available(iOS 13.0, macOS 10.15, *)
extension HorizontalRangeSliderStyle where Thumb == DefaultThumb, LowerThumb == DefaultThumb, UpperThumb == DefaultThumb, ThumbOverlay == DefaultThumb, Track == DefaultHorizontalRangeTrack {
    public init(thumbSize: CGSize = CGSize(width: 27, height: 27), lowerThumbSize: CGSize = CGSize(width: 27, height: 27), upperThumbSize: CGSize = CGSize(width: 27, height: 27), thumbInteractiveSize: CGSize = CGSize(width: 44, height: 44), lowerThumbInteractiveSize: CGSize = CGSize(width: 44, height: 44), upperThumbInteractiveSize: CGSize = CGSize(width: 44, height: 44), options: RangeSliderOptions = .defaultOptions) {
        self.track = DefaultHorizontalRangeTrack()
        self.thumb = DefaultThumb()
        self.lowerThumb = DefaultThumb()
        self.upperThumb = DefaultThumb()
        self.thumbOverlay = DefaultThumb()
        self.thumbSize = thumbSize
        self.lowerThumbSize = lowerThumbSize
        self.upperThumbSize = upperThumbSize
        self.thumbInteractiveSize = thumbInteractiveSize
        self.lowerThumbInteractiveSize = lowerThumbInteractiveSize
        self.upperThumbInteractiveSize = upperThumbInteractiveSize
        self.options = options
    }
}

@available(iOS 13.0, macOS 10.15, *)
public struct DefaultHorizontalRangeTrack: View {
    public var body: some View {
        HorizontalRangeTrack()
            .frame(height: 3)
            .background(Color.secondary.opacity(0.25))
            .cornerRadius(1.5)
    }
}
