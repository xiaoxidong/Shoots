import SwiftUI

@available(iOS 13.0, macOS 10.15, *)
extension EnvironmentValues {
    var rangeTrackConfiguration: RangeTrackConfiguration {
        get {
            return self[RangeTrackConfigurationKey.self]
        }
        set {
            self[RangeTrackConfigurationKey.self] = newValue
        }
    }
}

@available(iOS 13.0, macOS 10.15, *)
struct RangeTrackConfigurationKey: EnvironmentKey {
    static let defaultValue: RangeTrackConfiguration = .defaultConfiguration
}
