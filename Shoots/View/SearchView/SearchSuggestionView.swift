//
//  SearchSuggestionView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/6/15.
//

import SwiftUI

struct SearchSuggestionView: View {
    @Binding var searchText: String
    @Binding var patterns: [Pattern]
    @Binding var apps: [AppInfo]
    
    @EnvironmentObject var info: InfoViewModel
    @EnvironmentObject var search: SearchViewModel
    var body: some View {
        ScrollView {
            ForEach(apps) { app in
                Button {
                    searchText = app.linkApplicationName
                    search.appID = app.id
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
    }
}

struct SearchSuggestionView_Previews: PreviewProvider {
    static var previews: some View {
        SearchSuggestionView(searchText: .constant(""), patterns: .constant([]), apps: .constant([]))
    }
}
