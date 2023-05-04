//
//  ShootsAIView.swift
//  Shoots_Mac
//
//  Created by XiaoDong Yuan on 2023/3/31.
//

import SwiftUI

struct ShootsAIView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Text("Shoots AI")
                    .font(.largeTitle)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }.padding([.horizontal, .top])
        }
    }
}

struct ShootsAIView_Previews: PreviewProvider {
    static var previews: some View {
        ShootsAIView()
            .previewDisplayName("Chinese")
            .environment(\.locale, .init(identifier: "zh-cn"))
        
        ShootsAIView()
            .previewDisplayName("English")
            .environment(\.locale, .init(identifier: "en"))
    }
}
