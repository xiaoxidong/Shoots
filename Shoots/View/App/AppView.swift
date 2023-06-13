//
//  AppView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/20.
//

import SwiftUI

struct AppView: View {
    var id: String
//    var app: Application = Application(name: "Instagram", image: "Instagram", type: "社交", info: appInfo, url: "https://apps.apple.com/us/app/id389801252", flows: flows)
    var topPadding: CGFloat = 0
    
    @State var footerRefreshing = false
    @State var noMore = false
    @EnvironmentObject var user: UserViewModel
    @State var detail: AppDetailResponseData? = nil
    
    var body: some View {
        ScrollView {
            Group {
                header
                if true {
                    flowView
                }
                imagesView
                
                LoadMoreView(footerRefreshing: $footerRefreshing, noMore: $noMore) {
                    loadMore()
                }
            }.frame(maxWidth: 1060)
                .frame(maxWidth: .infinity)
        }.enableRefresh()
            .refreshable {
                // 下拉刷新
                
            }
            .onAppear {
                Task {
                    await user.getAppDetail(id: id) { success in
                        self.detail = success
                    }
                    await user.appFlows(id: id)
                    await user.appPics(id: id)
                }
            }
    }
    
    @ViewBuilder
    var header: some View {
        if let detail = detail, let pic = detail.applicationTypeName {
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    Image(detail.appLogoUrl ?? "")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 86, height: 86)
                        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                    
                    VStack(alignment: .leading) {
                        Text(detail.linkApplicationName ?? "")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.shootBlack)
                        Text(detail.applicationTypeName ?? "")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.shootGray)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 4)
                            .background(Color.shootBlue.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                    }
                    Spacer()
                    
                    Button {
                        if let url = URL(string: detail.appUrl ?? "") {
                            #if os(iOS)
                            UIApplication.shared.open(url)
                            #else
                            NSWorkspace.shared.open(url)
                            #endif
                        }
                    } label: {
                        HStack(spacing: 2) {
                            Text("App Store")
                            Image(systemName: "chevron.forward")
                        }.font(.system(size: 16, weight: .bold))
                            .foregroundColor(.shootBlue)
                    }.buttonStyle(.plain)
                }
                
                Text(detail.description ?? "")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.shootBlack)
                    .lineLimit(3)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
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
                    ForEach(1...4, id: \.self) { flow in
//                        FolderCardView(images: flow.images, name: flow.name, picCount: 10)
//                            .frame(height: 286)
//                            .onTapGesture {
//                                self.flow = flow
//                            }
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
            
            FeedView(shoots: user.appFeed)
        }.padding(.top, 26)
    }
    
    func loadMore() {
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
            footerRefreshing = false
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AppView(id: "")
        }
            .previewDisplayName("Chinese")
            .environment(\.locale, .init(identifier: "zh-cn"))
        
        NavigationView {
            AppView(id: "")
        }
            .previewDisplayName("English")
            .environment(\.locale, .init(identifier: "en"))
    }
}
