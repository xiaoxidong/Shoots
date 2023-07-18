//
//  AppView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct AppView: View {
    var id: String
    var appID: String?
    var topPadding: CGFloat = 0
    
    @StateObject var app: AppViewModel = AppViewModel()
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                header
                if !app.flows.isEmpty {
                    flowView
                }
                imagesView
                
                LoadMoreView(footerRefreshing: $app.footerRefreshing, noMore: $app.noMore) {
                    Task {
                        await app.nextPage(id: id)
                    }
                }
            }.frame(maxWidth: 1060)
                .frame(maxWidth: .infinity)
        }.enableRefresh()
            .refreshable {
                // 下拉刷新
                Task {
                    await loadData()
                }
            }
            .task {
                await loadData()
            }
    }
    
    func loadData() async {
        if let appID = appID {
            await app.info(id: appID)
        }
        
        await app.getAppDetail(id: id) { success in
            
        }
        await app.appFlows(id: id)
        await app.appPics(id: id)
    }
    
    @State var showDetailInfo = false
    @ViewBuilder
    var header: some View {
        if let info = app.info {
            VStack(spacing: 16) {
                HStack(spacing: 16) {
//                    WebImage(url: URL(string: info.artworkUrl512)!)
//                        // Supports options and context, like `.delayPlaceholder` to show placeholder only when error
//                        .onSuccess { image, data, cacheType in
//                            // Success
//                            // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
//                        }
//                        .resizable() // Resizable like SwiftUI.Image, you must use this modifier or the view will use the image bitmap size
//
//                        // Supports ViewBuilder as well
//                        .placeholder {
//                            Rectangle()
//                                .foregroundColor(.gray.opacity(0.1))
//                                .overlay {
//                                    Image(systemName: "photo")
//                                        .font(.system(size: 20))
//                                        .foregroundColor(.gray.opacity(0.8))
//                                }
//                        }
//                        .indicator(.activity) // Activity Indicator
//                        .transition(.fade(duration: 0.5)) // Fade Transition with duration
//                        .scaledToFit()
                    ImageView(urlString: info.artworkUrl512, image: .constant(nil))
                        .frame(width: 86, height: 86)
                        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                        .shadow(color: Color.gray.opacity(0.2), radius: 8, x: 0, y: 0)
                    
                    VStack(alignment: .leading) {
                        Text(info.trackName)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.shootBlack)
                            .lineLimit(1)
                            .fixedSize(horizontal: false, vertical: true)
                        HStack(spacing: 6) {
                            ForEach(info.genres, id: \.self) { text in
                                Text(text)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.shootGray)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 4)
                                    .background(Color.shootBlue.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                            }
                        }
                        Button {
                            if let url = URL(string: info.trackViewUrl) {
                                #if os(iOS)
                                UIApplication.shared.open(url)
                                #else
                                NSWorkspace.shared.open(url)
                                #endif
                            }
                        } label: {
                            HStack(spacing: 2) {
                                Text("App Store")
                                    .font(.system(size: 16, weight: .bold))
                                Image(systemName: "chevron.forward")
                                    .font(.system(size: 14, weight: .bold))
                                    .padding(.top, 1)
                            }.foregroundColor(.shootBlue)
                        }.buttonStyle(.plain)
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Text(showDetailInfo ? info.description : info.descriptionWithoutSpace)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.shootBlack)
                    .lineLimit(showDetailInfo ? nil : 4)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showDetailInfo.toggle()
                        }
                    }
            }.padding(.horizontal).padding(.top, topPadding)
        }
    }
    
    @State var flow: Flow? = nil
    var flowView: some View {
        VStack {
            Text("设计流")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.shootBlack)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 36) {
                    ForEach(app.flows) { flow in
                        FolderCardView(images: flow.images, name: flow.name, picCount: 10)
                            .frame(height: 286)
                            .onTapGesture {
                                self.flow = flow
                            }
                    }
                }.padding(.horizontal, 36)
            }
        }.padding(.top, 26)
        #if os(iOS)
            .fullScreenCover(item: $flow) { flow in
                FlowView(flow: flow)
            }
        #else
            .sheet(item: $flow) { flow in
                FlowView(flow: flow)
                    .sheetFrameForMac()
            }
        #endif
    }
    
    var imagesView: some View {
        VStack {
            Text("应用截图")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.shootBlack)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            
            FeedView(shoots: app.appFeed)
        }.padding(.top, 26)
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AppView(id: "", appID: "6446901002")
        }
        .previewDisplayName("Chinese")
        .environment(\.locale, .init(identifier: "zh-cn"))
        
        NavigationView {
            AppView(id: "", appID: "6446901002")
        }
        .previewDisplayName("English")
        .environment(\.locale, .init(identifier: "en"))
    }
}
