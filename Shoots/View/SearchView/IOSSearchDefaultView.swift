//
//  SearchView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/20.
//

import SwiftUI

struct IOSSearchDefaultView: View {
    @Binding var searchText: String
    
    var body: some View {
        ScrollView {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 26) {
                    ForEach(apps) { app in
                        Button {
                            searchText = app.name
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
                        searchText = "关注"
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

struct SearchDefaultView_Previews: PreviewProvider {
    static var previews: some View {
        IOSSearchDefaultView(searchText: .constant(""))
    }
}