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
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                if images.count >= 1 {
                    Image(images[0])
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .rotationEffect(Angle(degrees: -3))
                } else {
                    Image("s1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .rotationEffect(Angle(degrees: -3))
                }
                
                
                if images.count >= 2 {
                    Image(images[1])
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .rotationEffect(Angle(degrees: -6))
                } else {
                    Image("s1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                
                if images.count >= 3 {
                    Image(images[2])
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                } else {
                    Image("s1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
            }
            .frame(maxWidth: 156, maxHeight: 286)
            .padding(.top)
            .shadow(color: Color.shootBlack.opacity(0.1), radius: 8)
            .overlay(alignment: .bottomLeading) {
                Text("\(images.count) 张")
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
        }
    }
}

struct FolderCardView_Previews: PreviewProvider {
    static var previews: some View {
        FolderCardView(images: ["s2", "s5", "s6"], name: "注册")
    }
}
