//
//  ActionTitleButtonView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/20.
//

import SwiftUI

struct ActionTitleButtonView: View {
    var image: String
    var title: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.shootBlack)
            }
        }.buttonStyle(.plain)
    }
}

struct ActionTitleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ActionTitleButtonView(image: "saved", title: "已收藏") {
            
        }
    }
}
