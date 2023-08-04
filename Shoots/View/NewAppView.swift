//
//  NewAppView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/7/14.
//

import SwiftUI

struct NewAppView: View {
    let appID: String

    @State var tags: [String] = ["Apple", "Shoots"]
    var body: some View {
//        Text("Hello, World!")
        TagField(tags: $tags)
    }
}

struct NewAppView_Previews: PreviewProvider {
    static var previews: some View {
        NewAppView(appID: "")
    }
}
