// Kevin Li - 6:35 PM - 6/23/20

import Combine
import SwiftUI

public class ElegantListManager: ObservableObject {

    @Published var currentPage: (index: Int, state: PageState)
    @Published var activeIndex: Int

    public let pageCount: Int

    let maxPageIndex: Int

    public var currentPageIndex: Int {
        currentPage.index
    }

    var anyCancellable: AnyCancellable?

    public init(startingPage: Int = 0, pageCount: Int) {
        guard pageCount > 0 else { fatalError("Error: pages must exist") }

        currentPage = (startingPage, .completed)
        self.pageCount = pageCount
        maxPageIndex = (pageCount-1).clamped(to: 0...2)

        if startingPage == 0 {
            activeIndex = 0
        } else if startingPage == pageCount-1 {
            activeIndex = maxPageIndex
        } else {
            activeIndex = 1
        }
    }

    public func scroll(to page: Int, animated: Bool = true) {
        currentPage = (page, .scroll(animated: animated))
    }

    public func reloadPages() {
        currentPage = (currentPage.index, .scroll(animated: false))
    }

    // Only ever called for a page view with more than 3 pages
    func setCurrentPageToBeRearranged() {
        var currentIndex = currentPage.index

        // only ever called when turning from the first or last page
        if activeIndex == 1 {
            if currentIndex == 0 {
                // just scrolled from first page to second page
                currentIndex += 1
            } else if currentIndex == pageCount-1 {
                // just scrolled from last page to second to last page
                currentIndex -= 1
            } else {
                return
            }
        } else {
            if activeIndex == 0 {
                // case where you're on the first page and you drag and stay on the first page
                guard currentIndex != 0 else { return }
                currentIndex -= 1
            } else if activeIndex == 2 {
                // case where you're on the last page and you drag and stay on the last page
                guard currentIndex != pageCount-1 else { return }
                currentIndex += 1
            }
        }

        currentPage = (currentIndex, .rearrange)
    }

}

protocol ElegantListManagerDirectAccess {

    var manager: ElegantListManager { get }

}

extension ElegantListManagerDirectAccess {

    var currentPage: (index: Int, state: PageState) {
        manager.currentPage
    }

    var pageCount: Int {
        manager.pageCount
    }

    var activeIndex: Int {
        manager.activeIndex
    }

    var maxPageIndex: Int {
        manager.maxPageIndex
    }

}
