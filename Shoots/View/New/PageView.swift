//
//  PageView.swift
//  Connect
//
//  Created by XiaoDong Yuan on 2022/11/30.
//

import SwiftUI

struct PageView: View {
    
    let page: PageData
    let imageWidth: CGFloat = 450
    let textWidth: CGFloat = 350
    
    var body: some View {
        #if os(iOS)
        let size = UIImage(named: page.imageName)?.size ?? .zero
        #else
        let size = NSImage(named: page.imageName)?.size ?? .zero
        #endif
        let aspect = size.width / size.height
        
        return VStack(alignment: .center, spacing: 50) {
//            Text(page.title)
//                .font(.system(size: 26, weight: .medium, design: .rounded))
//                .foregroundColor(page.textColor)
//                .frame(maxWidth: textWidth)
//                .multilineTextAlignment(.center)
            Spacer()
            Image(page.imageName)
                .resizable()
                .aspectRatio(aspect, contentMode: .fit)
                .frame(maxWidth: imageWidth, maxHeight: imageWidth)
                .cornerRadius(40)
                .clipped()
                
            VStack(alignment: .center, spacing: 16) {
                Text(LocalizedStringKey(page.header))
                #if os(iOS)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                #else
                    .font(.system(size: 22, weight: .medium, design: .rounded))
                #endif
                    .foregroundColor(page.textColor)
                    .frame(maxWidth: 360, alignment: .center)
                    .multilineTextAlignment(.center)
                Text(LocalizedStringKey(page.content))
                #if os(iOS)
                    .font(Font.system(size: 16, weight: .medium, design: .rounded))
                #else
                    .font(Font.system(size: 16, weight: .regular, design: .rounded))
                #endif
                    .foregroundColor(page.textColor)
                    .frame(maxWidth: 360, alignment: .center)
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
            }
            Spacer()
            Spacer()
        }.padding(.horizontal, 26)
    }
}

//struct PageView_Previews: PreviewProvider {
//    static var previews: some View {
//        PageView()
//    }
//}
