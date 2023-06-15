//
//  IOSSearchView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/20.
//

import SwiftUI

struct IOSSearchView: View {
    @Binding var searchText: String
    
    @EnvironmentObject var info: InfoViewModel
    @EnvironmentObject var search: SearchViewModel
    @State var patterns: [Pattern] = []
    @State var apps: [AppInfo] = []
    var body: some View {
        Group {
            if search.showResult && !searchText.isEmpty {
                SearchResultView()
            } else {
                if searchText != "" {
                    SearchSuggestionView(searchText: $searchText, patterns: $patterns, apps: $apps)
                } else {
                    defaultView
                }
            }
        }.onChange(of: searchText) { newValue in
            if newValue == "" {
                search.showResult = false
            }
            // TODO: 处理下 isOfficial 为 nil 的情况
            patterns = info.patterns.filter({ $0.designPatternName.lowercased().contains(newValue.lowercased()) }).sorted(by: { $0.isOfficial > $1.isOfficial })
            apps = info.apps.filter({ $0.linkApplicationName.lowercased().contains(newValue.lowercased()) }).sorted(by: { $0.isOfficial > $1.isOfficial })
        }
    }
    
    var defaultView: some View {
        ScrollView {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 26) {
                    ForEach(info.apps) { app in
                        Button {
                            searchText = app.linkApplicationName
                            search.appID = app.id
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
            VStack(spacing: 0) {
                ForEach(info.patterns) { pattern in
                    Button {
                        searchText = pattern.designPatternName
                        search.patternID = pattern.id
                        Task {
                            await search.getPatternPics(id: pattern.id)
                        }
                    } label: {
                        VStack(spacing: 20) {
                            Text(pattern.designPatternName)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.shootBlack)
                            + Text(" (\(pattern.count ?? ""))")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.shootGray)
                            Divider()
                                .padding(.horizontal)
                        }.padding(.top, 20)
                            .frame(maxWidth: .infinity)
                            .contentShape(Rectangle())
                    }
                }
            }.padding(.top)
                .padding(.bottom, 400)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear {
            Task {
                await info.getApps()
                await info.getAllPatterns()
            }
        }
    }
}

struct SearchDefaultView_Previews: PreviewProvider {
    static var previews: some View {
        IOSSearchView(searchText: .constant(""))
            .previewDisplayName("Chinese")
            .environment(\.locale, .init(identifier: "zh-cn"))
        IOSSearchView(searchText: .constant(""))
            .previewDisplayName("English")
            .environment(\.locale, .init(identifier: "en"))
    }
}
