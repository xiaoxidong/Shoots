//
//  FolderCardView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/21.
//

import SwiftUI

struct FolderCardView: View {
    var images: [String]
    var name: String
    var picCount: Int
    
    @State var hover = false
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Group {
                    if images.count >= 3 {
                        ImageView(urlString: images[2], image: .constant(nil))
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .rotationEffect(Angle(degrees: hover ? -16 : -8))
                                .shadow(color: Color.shootBlack.opacity(0.1), radius: 8)
                    } else {
                        two
                            .rotationEffect(Angle(degrees: hover ? -8 : -4))
                    }
                }
                two
                one.rotationEffect(Angle(degrees: hover ? 4 : 0))
            }
            .frame(maxWidth: 156, maxHeight: 286)
            .padding(.top)
//            .shadow(color: Color.shootLight.opacity(0.1), radius: 8)
            .overlay(alignment: .bottomLeading) {
                Text("\(picCount) 张")
                    .font(.system(size: 14, weight: .bold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .foregroundColor(.white)
                    .background(Color.shootRed.opacity(0.9))
                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                    .padding(6)
                    .offset(x: -4)
            }
            
            Text(name)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.shootBlack)
                .frame(maxWidth: 126)
                .lineLimit(1)
        }.onHover { hover in
            withAnimation(.spring()) {
                self.hover = hover
            }
        }
    }
    
    var one: some View {
        Group {
            if images.count >= 1 {
                ImageView(urlString: images[0], image: .constant(nil))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    
            } else {
                Color.shootWhite
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .contentShape(Rectangle())
                    .shadow(color: Color.shootBlack.opacity(0.06), radius: 10)
            }
        }
    }
    
    var two: some View {
        Group {
            if images.count >= 2 {
                ImageView(urlString: images[1], image: .constant(nil))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            } else {
                one
            }
        }.rotationEffect(Angle(degrees: hover ? -6 : -4))
            .shadow(color: Color.shootBlack.opacity(0.1), radius: 8)
    }
}

struct FolderCardView_Previews: PreviewProvider {
    static var previews: some View {
        FolderCardView(images: ["s2", "s1"], name: "注册", picCount: 10)
            .previewDisplayName("Chinese")
            .environment(\.locale, .init(identifier: "zh-cn"))
        
        FolderCardView(images: ["s2", "s1"], name: "注册", picCount: 10)
            .previewDisplayName("English")
            .environment(\.locale, .init(identifier: "en"))
    }
}
