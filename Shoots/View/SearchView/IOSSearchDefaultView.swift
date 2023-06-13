//
//  SearchView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/20.
//

import SwiftUI

struct IOSSearchDefaultView: View {
    @Binding var searchText: String
    
    @EnvironmentObject var user: UserViewModel
    var body: some View {
        ScrollView {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 26) {
                    ForEach(user.apps) { app in
                        Button {
                            searchText = app.linkApplicationName
                        } label: {
                            VStack {
                                Image("Instagram")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 66, height: 66)
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                Text(app.linkApplicationName)
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
                ForEach(user.patterns) { pattern in
                    Button {
                        searchText = pattern.designPatternName
                    } label: {
                        Group {
                            Text(pattern.designPatternName)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.shootBlack)
                            + Text(" (\(pattern.count ?? ""))")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.shootGray)
                        }.padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .contentShape(Rectangle())
                    }

                }
            }.padding(.top)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear {
            Task {
                await user.getApps()
                await user.getAllPatterns()
            }
        }
    }
}

struct SearchDefaultView_Previews: PreviewProvider {
    static var previews: some View {
        IOSSearchDefaultView(searchText: .constant(""))
            .previewDisplayName("Chinese")
            .environment(\.locale, .init(identifier: "zh-cn"))
        IOSSearchDefaultView(searchText: .constant(""))
            .previewDisplayName("English")
            .environment(\.locale, .init(identifier: "en"))
    }
}
