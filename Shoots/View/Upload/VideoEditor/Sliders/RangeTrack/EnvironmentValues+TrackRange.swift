import SwiftUI

@available(iOS 13.0, macOS 10.15, *)
public extension EnvironmentValues {
    var trackRange: ClosedRange<CGFloat> {
        get {
            return self[TrackRangeKey.self]
        }
        set {
            self[TrackRangeKey.self] = newValue
        }
    }
}

@available(iOS 13.0, macOS 10.15, *)
public struct TrackRangeKey: EnvironmentKey {
    public static let defaultValue: ClosedRange<CGFloat> = 0.0...1.0
}
