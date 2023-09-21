//
//  ContainerView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/9/21.
//

import SwiftUI

struct ContainerView: View {
    @AppStorage("showNew") var showNew: Bool = true
    var body: some View {
        ZStack {
            if showNew {
                NewView(show: .constant(false))
                    .transition(AnyTransition.opacity.combined(with: .scale(scale: 0.8)).animation(Animation.default.speed(1.5)))
            } else {
                ContentView()
            }
        }
    }
}

struct ContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView()
    }
}
