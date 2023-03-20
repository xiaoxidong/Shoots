//
//  SearchView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/20.
//

import SwiftUI

struct SearchView: View {
    var body: some View {
        ScrollView {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 26) {
                    ForEach(apps) { app in
                        Button {
                            
                        } label: {
                            VStack {
                                Image(app.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 66, height: 66)
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                Text(app.name)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.shootBlack)
                            }
                        }
                    }
                }.padding(.horizontal)
                    .padding(.top)
            }
            
            // Tag
            VStack(spacing: 16) {
                ForEach(1...100, id: \.self) { num in
                    Button {
                        
                    } label: {
                        Group {
                            Text("关注")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.shootBlack)
                            + Text(" (24)")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.shootGray)
                        }.padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .contentShape(Rectangle())
                    }

                }
            }.padding(.top)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
