//
//  IOSSearchView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/20.
//

import SwiftUI

struct SearchView: View {
    @Binding var searchText: String
    var showSearchDefault: Bool = true
    var showSearchSuggestion: Bool = true
    var showSearchBackground: Bool = true

    @EnvironmentObject var info: InfoViewModel
    @EnvironmentObject var search: SearchViewModel
    var body: some View {
        Group {
            if search.showResult && !searchText.isEmpty {
                SearchResultView()
            } else {
                if showSearchSuggestion && searchText != "" {
                    SearchSuggestionView(searchText: $searchText)
                } else if showSearchDefault {
                    defaultView
                }
            }
        }.background(showSearchBackground ? Color.shootWhite : .clear)
            .onChange(of: searchText) { newValue in
                if newValue == "" {
                    search.showResult = false
                }
            }
    }

    var defaultView: some View {
        ScrollView {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 26) {
                    ForEach(info.suggestionApps) { app in
                        Button {
                            searchText = app.linkApplicationName
                            search.appID = app.id
                            search.appStoreID = app.appStoreId
                            self.resignFirstResponder()
                        } label: {
                            VStack {
                                if let logo = app.appLogoUrl {
                                    ImageView(urlString: logo, image: .constant(nil))
                                        .frame(width: 66, height: 66)
                                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                        .shadow(color: Color.gray.opacity(0.2), radius: 8, x: 0, y: 0)
                                } else {
                                    Image("Instagram")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 66, height: 66)
                                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                }

                                Text(app.linkApplicationName)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.shootBlack)
                            }
                        }.buttonStyle(.plain)
                    }
                }.padding(.horizontal)
                    .padding(.top)
            }

            // Tag
            VStack(spacing: 0) {
                ForEach(info.suggestionPatterns) { pattern in
                    Button {
                        searchText = pattern.designPatternName.localized
                        search.patternID = pattern.id
                        Task {
                            await search.getPatternPics(id: pattern.id)
                        }
                        self.resignFirstResponder()
                    } label: {
                        VStack(spacing: 20) {
                            Text(LocalizedStringKey(pattern.designPatternName))
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.shootBlack)
                                + Text(" (\(pattern.count))")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.shootGray)
                            Divider()
                                .padding(.horizontal)
                        }.padding(.top, 20)
                            .frame(maxWidth: .infinity)
                            .contentShape(Rectangle())
                    }.buttonStyle(.plain)
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
        SearchView(searchText: .constant(""))
            .previewDisplayName("Chinese")
            .environment(\.locale, .init(identifier: "zh-cn"))
            .environmentObject(InfoViewModel())
            .environmentObject(SearchViewModel())
        SearchView(searchText: .constant(""))
            .previewDisplayName("English")
            .environment(\.locale, .init(identifier: "en"))
            .environmentObject(InfoViewModel())
            .environmentObject(SearchViewModel())
    }
}
