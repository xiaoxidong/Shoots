// Kevin Li - 6:41 PM - 6/23/20

import SwiftUI

struct ElegantPagesView<Stack>: View, ElegantPagesManagerDirectAccess where Stack: View {

    @State private var translation: CGFloat = .zero
    @State private var isDragging = false
    @State private var isTurningPage = false

    @ObservedObject var manager: ElegantPagesManager

    let stackView: Stack
    let pageCount: Int
    let isHorizontal: Bool
    let bounces: Bool

    private var minDragDistance: CGFloat {
        switch pageTurnType {
        case .regular(let delta):
            return delta*screen.width / 5
        case .earlyCutoff(let config):
            return config.pageTurnCutOff / 5
        }
    }

    var body: some View {
        stackView
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

                        if abs(axisOffset) > self.minDragDistance {
                            self.isDragging = true
                        }

                        withAnimation(self.pageTurnAnimation) {
                            self.setTranslationForOffset(axisOffset)
                            self.turnPageIfNeededForChangingOffset(axisOffset)
                        }
                    }
                    .onEnded { value in
                        guard self.isDragging else { return }

                        let axisOffset = self.isHorizontal ? value.translation.width : value.translation.height

                        self.isDragging = false

                        withAnimation(self.pageTurnAnimation) {
                            self.turnPageIfNeededForEndOffset(axisOffset)
                        }
                },
                including: isDragging ? .gesture : .all
            )
    }

}

private extension ElegantPagesView {

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
        -CGFloat(currentPage) * screen.width
    }

    var verticalOffset: CGFloat {
        -CGFloat(currentPage) * screen.height
    }

    var verticalScrollOffset: CGFloat {
        verticalOffset + properTranslation
    }

    var properTranslation: CGFloat {
        guard !bounces else { return translation }

        if (currentPage == 0 && translation > 0) ||
            (currentPage == pageCount-1 && translation < 0) {
            return 0
        }
        return translation
    }

}

private extension ElegantPagesView {

    private func setTranslationForOffset(_ offset: CGFloat) {
        switch pageTurnType {
        case .regular:
            translation = offset
        case let .earlyCutoff(config):
            translation = isTurningPage ? .zero : (offset / config.pageTurnCutOff) * config.scrollResistanceCutOff
        }
    }

    private func turnPageIfNeededForChangingOffset(_ offset: CGFloat) {
        switch pageTurnType {
        case .regular:
            return
        case let .earlyCutoff(config):
            guard !isTurningPage else { return }

            if offset > 0 && offset > config.pageTurnCutOff {
                guard currentPage != 0 else { return }

                scroll(direction: .backward)
            } else if offset < 0 && offset < -config.pageTurnCutOff {
                guard currentPage != pageCount-1 else { return }

                scroll(direction: .forward)
            }
        }
    }

    private func scroll(direction: ScrollDirection) {
        isTurningPage = true // Prevents user drag from continuing
        translation = .zero

        manager.currentPage = currentPage + direction.additiveFactor
    }

    private func turnPageIfNeededForEndOffset(_ offset: CGFloat) {
        translation = .zero

        switch pageTurnType {
        case let .regular(delta):
            let axisLength = isHorizontal ? screen.width : screen.height
            let dragDelta = offset / axisLength

            if abs(dragDelta) > delta {
                let properNewIndex = (dragDelta > 0 ? currentPage-1 : currentPage+1).clamped(to: 0...pageCount-1)
                if properNewIndex != currentPage {
                    manager.currentPage = properNewIndex
                }
            }
        case .earlyCutoff:
            isTurningPage = false
        }
    }

}
