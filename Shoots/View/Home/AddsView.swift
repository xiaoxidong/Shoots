//
//  AddsView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/4/3.
//

import SwiftUI

struct AddsView: View {
    @State var showAdds = false
    var body: some View {
        Image("adds")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .onTapGesture {
                #if os(iOS)
                showAdds.toggle()
                #else
                // Mac 下直接打开链接
                #endif
            }
        #if os(iOS)
            .sheet(isPresented: $showAdds) {
                SafariView(url: URL(string: "https://www.baidu.com/")!)
            }
        #endif
    }
}

struct AddsView_Previews: PreviewProvider {
    static var previews: some View {
        AddsView()
            .previewDisplayName("Chinese")
            .environment(\.locale, .init(identifier: "zh"))
        AddsView()
            .previewDisplayName("English")
            .environment(\.locale, .init(identifier: "en"))
    }
}
