import SwiftUI

@available(iOS 13.0, macOS 10.15, *)
public struct DefaultHorizontalValueView: View {
    public var body: some View {
        Capsule()
            .foregroundColor(Color.accentColor)
            .frame(height: 3)
    }
}
