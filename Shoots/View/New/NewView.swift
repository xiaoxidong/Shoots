//
//  NewView.swift
//  Connect
//
//  Created by XiaoDong Yuan on 2022/11/23.
//

import SwiftUI

struct NewView: View {
    @Binding var show: Bool
    
    @AppStorage("showNew") var showNew: Bool = true
    @State var last = false
    
    var body: some View {
        ConcentricOnboardingView(pageContents: MockData.pages.map { (PageView(page: $0), $0.color) })
            .duration(1)
            .nextIcon(last ? "checkmark" : "chevron.forward")
            .animationDidEnd {
                if last {
                    showNew = false
                    show.toggle()
                    last = false
                }
            }
            .didGoToLastPage {
                last = true
            }
            .edgesIgnoringSafeArea(.all)
    }
    
}

