// Kevin Li - 8:48 PM - 6/23/20

import SwiftUI

struct ElegantListView<List>: View, ElegantListManagerDirectAccess, PageTurnTypeDirectAccess where List: View {

    @State private var translation: CGFloat = .zero
    @State private var isTurningPage = false

    @ObservedObject var manager: ElegantListManager

    let listView: List
    let isHorizontal: Bool
    let pageTurnType: PageTurnType
    let bounces: Bool

    public var body: some View {
        listView
            .offset(offset)
            .contentShape(Rectangle())
            .simultaneousGesture(
                DragGesture()
                    .onChanged { value in
                        let axisOffset = self.isHorizontal ? value.translation.width : value.translation.height
                        let nonAxisOffset = self.isHorizontal ? value.translation.height : value.translation.width

                        guard abs(nonAxisOffset) < abs(axisOffset) else {
                            self.translation = .zero
                            return
                        }

                        withAnimation(self.pageTurnAnimation) {
                            self.setTranslationForOffset(axisOffset)
                            self.turnPageIfNeededForChangingOffset(axisOffset)
                        }
                    }
                    .onEnded { value in
                        let axisOffset = self.isHorizontal ? value.translation.width : value.translation.height
                        withAnimation(self.pageTurnAnimation) {
                            self.turnPageIfNeededForEndOffset(axisOffset)
                        }
                    }
            )
    }

}

private extension ElegantListView {

    var offset: CGSize {
        if isHorizontal {
            return CGSize(width: horizontalScrollOffset, height: 0.0)
        } else {
            return CGSize(width: 0.0, height: verticalScrollOffset)
        }
    }

    var horizontalScrollOffset: CGFloat {
        horizontalOffset + properTranslation
    }

    var horizontalOffset: CGFloat {
        -CGFloat(activeIndex) * screen.width
    }

    var verticalOffset: CGFloat {
        -CGFloat(activeIndex) * screen.height
    }

    var verticalScrollOffset: CGFloat {
        verticalOffset + properTranslation
    }

    var properTranslation: CGFloat {
        guard !bounces else { return translation }

        if (activeIndex == 0 && translation > 0) ||
            (activeIndex == maxPageIndex && translation < 0) {
            return 0
        }
        return translation
    }

}

private extension ElegantListView {

    func setTranslationForOffset(_ offset: CGFloat) {
        switch pageTurnType {
        case .regular:
            translation = offset
        case let .earlyCutoff(config):
            translation = isTurningPage ? .zero : (offset / config.pageTurnCutOff) * config.scrollResistanceCutOff
        }
    }

    func turnPageIfNeededForChangingOffset(_ offset: CGFloat) {
        switch pageTurnType {
        case .regular:
            return
        case let .earlyCutoff(config):
            guard !isTurningPage else { return }

            if offset > 0 && offset > config.pageTurnCutOff {
                guard activeIndex != 0 else { return }

                scroll(direction: .backward)
            } else if offset < 0 && offset < -config.pageTurnCutOff {
                guard activeIndex != maxPageIndex else { return }

                scroll(direction: .forward)
            }
        }
    }

    func scroll(direction: ScrollDirection) {
        isTurningPage = true // Prevents user drag from continuing
        translation = .zero

        manager.activeIndex = activeIndex + direction.additiveFactor
        manager.setCurrentPageToBeRearranged()
    }

    func turnPageIfNeededForEndOffset(_ offset: CGFloat) {
        translation = .zero

        switch pageTurnType {
        case let .regular(delta):
            let axisLength = isHorizontal ? screen.width : screen.height
            let dragDelta = offset / axisLength

            if abs(dragDelta) > delta {
                let properNewIndex = (dragDelta > 0 ? activeIndex-1 : activeIndex+1).clamped(to: 0...maxPageIndex)
                manager.activeIndex = properNewIndex
                manager.setCurrentPageToBeRearranged()
            }
        case .earlyCutoff:
            isTurningPage = false
        }
    }

}
