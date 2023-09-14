//
//  SearchAppsView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/9/13.
//

import SwiftUI

struct SearchAppsView: View {
    let setNameAction: (String) -> Void
    let setIDAction: (String) -> Void
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var info: InfoViewModel
    @EnvironmentObject var search: SearchViewModel
    @StateObject var appVM = AppViewModel()
    @AppStorage("showSearchAppsNew") var showSearchAppsNew = true
    
    @State var searchText = ""
    @State var appName = ""
    @State var apps: [AppInfo] = []
    @State var showResult = false
    @FocusState var focused: Bool
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                if showResult {
                    if appVM.loading {
                        LoadingView()
                            .padding(.top, 366)
                    } else {
                        if appVM.appFeed.isEmpty {
                            ShootEmptyView()
                                .padding(.top, 366)
                        } else {
                            SelectionFeedView(shoots: appVM.appFeed) { shoot in
                                setNameAction(appName)
                                setIDAction(shoot.id)
                                dismiss()
                            }
                        }
                    }
                } else {
                    suggestionView
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 12))
                            .foregroundColor(.shootGray)
                        TextField("搜索应用", text: $searchText)
                            .focused($focused)
                        Button {
                            dismiss()
                        } label: {
                            Text("取消")
                                .bold()
                        }

                    }
                }
            }
        }
        .onChange(of: searchText) { newValue in
            if showResult && searchText == "" {
                showResult = false
            }
            apps = info.apps.filter { $0.linkApplicationName.localized.lowercased().contains(newValue.lowercased()) }.sorted(by: { $0.isOfficial > $1.isOfficial })
        }
        .onAppear {
            focused = true
        }
    }
    
    @ViewBuilder
    var suggestionView: some View {
        if searchText == "" {
            VStack(spacing: 0) {
                ForEach(info.suggestionApps) { app in
                    SuggestionButtonView(image: "app.badge.fill", name: app.linkApplicationName) {
                        showResult = true
                        searchText = app.linkApplicationName
                        appName = app.linkApplicationName
                        Task {
                            await appVM.appPics(id: app.id)
                        }
                    }
                }
            }
        } else {
            VStack(spacing: 0) {
                ForEach(apps) { app in
                    SuggestionButtonView(image: "app.badge.fill", name: app.linkApplicationName) {
                        showResult = true
                        searchText = app.linkApplicationName
                        appName = app.linkApplicationName
                        Task {
                            await appVM.appPics(id: app.id)
                        }
                    }
                }
            }
        }
    }
}

struct SearchAppsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchAppsView { name in
            
        } setIDAction: { id in
            
        }
        .environmentObject(InfoViewModel())
        .environmentObject(SearchViewModel())
    }
}
