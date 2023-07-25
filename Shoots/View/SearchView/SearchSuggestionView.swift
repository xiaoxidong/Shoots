//
//  SearchSuggestionView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/6/15.
//

import SwiftUI

struct SearchSuggestionView: View {
    @Binding var searchText: String

    @State var patterns: [Pattern] = []
    @State var apps: [AppInfo] = []

    @EnvironmentObject var info: InfoViewModel
    @EnvironmentObject var search: SearchViewModel
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                ForEach(apps) { app in
                    SuggestionButtonView(image: "app.badge.fill", name: app.linkApplicationName) {
                        searchText = app.linkApplicationName
                        search.appID = app.id
                        search.appStoreID = app.appStoreId
                        self.resignFirstResponder()
                    }
                }
                ForEach(patterns) { pattern in
                    SuggestionButtonView(image: "number", name: pattern.designPatternName) {
                        searchText = pattern.designPatternName
                        search.patternID = pattern.id
                        Task {
                            await search.getPatternPics(id: pattern.id)
                        }
                        self.resignFirstResponder()
                    }
                }
            }.padding(.bottom, 56)
        }.frame(maxWidth: 860)
            .frame(maxWidth: .infinity)
            .onChange(of: searchText) { newValue in
                update(newValue: newValue)
            }
            .onAppear {
                update(newValue: searchText)
                #if os(iOS)
//                update(newValue: searchText)
                #else
//                    patterns = info.patterns.filter { $0.isOfficial == "1" }
//                    apps = info.apps.filter { $0.isOfficial == "1" }
                #endif
            }
    }

    func update(newValue: String) {
        patterns = info.patterns.filter { $0.designPatternName.lowercased().contains(newValue.lowercased()) }.sorted(by: { $0.isOfficial > $1.isOfficial })
        apps = info.apps.filter { $0.linkApplicationName.lowercased().contains(newValue.lowercased()) }.sorted(by: { $0.isOfficial > $1.isOfficial })
    }
}

struct SearchSuggestionView_Previews: PreviewProvider {
    static var previews: some View {
        SearchSuggestionView(searchText: .constant(""))
            .environmentObject(InfoViewModel())
            .environmentObject(SearchViewModel())
    }
}
