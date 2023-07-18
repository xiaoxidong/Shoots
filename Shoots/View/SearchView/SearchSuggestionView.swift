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
        ScrollView {
            VStack(spacing: 0) {
                ForEach(apps) { app in
                    Button {
                        searchText = app.linkApplicationName
                        search.appID = app.id
                        search.appStoreID = app.appStoreId
                    } label: {
                        HStack {
                            Image(systemName: "app.badge.fill")
                                .bold()
                            Text(app.linkApplicationName)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.shootBlack)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .bold()
                                .foregroundColor(.shootGray)
                        }
                            .padding(.horizontal)
                            .padding(.vertical, 12)
                            .contentShape(Rectangle())
                    }.buttonStyle(.plain)
                }
                ForEach(patterns) { pattern in
                    Button {
                        searchText = pattern.designPatternName
                        search.patternID = pattern.id
                        Task {
                            await search.getPatternPics(id: pattern.id)
                        }
                    } label: {
                        HStack {
                            Image(systemName: "number")
                                .bold()
                            Text(pattern.designPatternName)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.shootBlack)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .bold()
                                .foregroundColor(.shootGray)
                        }
                            .padding(.horizontal)
                            .padding(.vertical, 12)
                            .contentShape(Rectangle())
                    }.buttonStyle(.plain)
                }
            }
        }.frame(maxWidth: 1060)
            .onChange(of: searchText) { newValue in
                update(newValue: newValue)
            }
            .onAppear {
                #if os(iOS)
                update(newValue: searchText)
                #else
                patterns = info.patterns.filter({ $0.isOfficial == "1" })
                apps = info.apps.filter({ $0.isOfficial == "1" })
                #endif
            }
    }
    
    func update(newValue: String) {
        patterns = info.patterns.filter({ $0.designPatternName.lowercased().contains(newValue.lowercased()) }).sorted(by: { $0.isOfficial > $1.isOfficial })
        apps = info.apps.filter({ $0.linkApplicationName.lowercased().contains(newValue.lowercased()) }).sorted(by: { $0.isOfficial > $1.isOfficial })
    }
}

struct SearchSuggestionView_Previews: PreviewProvider {
    static var previews: some View {
        SearchSuggestionView(searchText: .constant(""))
    }
}
