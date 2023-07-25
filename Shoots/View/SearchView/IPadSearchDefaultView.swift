//
//  IPadSearchDefaultView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/26.
//

import SwiftUI
import SwiftUIFlowLayout

struct IPadSearchDefaultView: View {
    @Binding var searchText: String

    let rows = [
        GridItem(.fixed(120), spacing: 12),
        GridItem(.fixed(120), spacing: 12),
    ]
    @EnvironmentObject var info: InfoViewModel
    @EnvironmentObject var search: SearchViewModel
    var body: some View {
        ScrollView(showsIndicators: false) {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: rows, alignment: .center, spacing: 0) {
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
                                        .frame(width: 86, height: 86)
                                        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                                        .shadow(color: Color.gray.opacity(0.2), radius: 8, x: 0, y: 0)
                                } else {
                                    Image("Instagram")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 86, height: 86)
                                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                }
                                Text(app.linkApplicationName)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.shootBlack)
                                    .frame(width: 106)
                                    .lineLimit(1)
                            }
                        }.buttonStyle(.plain)
                    }
                }
                .padding(.top)
            }

            // Tag
            FlowLayout(mode: .vstack,
                       items: info.patterns,
                       itemSpacing: 4)
            { pattern in
                Button {
                    searchText = pattern.designPatternName
                    search.patternID = pattern.id
                    Task {
                        await search.getPatternPics(id: pattern.id)
                    }
                    self.resignFirstResponder()
                } label: {
                    HStack(spacing: 2) {
                        Text(pattern.designPatternName)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.shootBlack)
                            + Text(" (\(pattern.count))")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.shootGray)
                    }.padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.shootBlue.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .padding(.vertical, 1)
                }.buttonStyle(.plain)
            }.padding(.top)
                .padding(.horizontal)
                .frame(minHeight: 1009, alignment: .top)
        }
    }
}

struct IPadSearchDefaultView_Previews: PreviewProvider {
    static var previews: some View {
        IPadSearchDefaultView(searchText: .constant(""))
            .previewDisplayName("Chinese")
            .environment(\.locale, .init(identifier: "zh-cn"))
            .environmentObject(InfoViewModel())
            .environmentObject(SearchViewModel())
        IPadSearchDefaultView(searchText: .constant(""))
            .previewDisplayName("English")
            .environment(\.locale, .init(identifier: "en"))
            .environmentObject(InfoViewModel())
            .environmentObject(SearchViewModel())
    }
}
