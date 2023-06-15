//
//  AppView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/20.
//

import SwiftUI

struct AppView: View {
    var id: String
    var topPadding: CGFloat = 0
    
    @StateObject var app: AppViewModel = AppViewModel()
    var body: some View {
        ScrollView {
            Group {
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
        await app.getAppDetail(id: id) { success in
            
        }
        await app.appFlows(id: id)
        await app.appPics(id: id)
    }
    
    @ViewBuilder
    var header: some View {
        if let app = app.app, let pic = app.applicationTypeName {
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    Image(app.appLogoUrl ?? "")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 86, height: 86)
                        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                    
                    VStack(alignment: .leading) {
                        Text(app.linkApplicationName ?? "")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.shootBlack)
                        Text(app.applicationTypeName ?? "")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.shootGray)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 4)
                            .background(Color.shootBlue.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                    }
                    Spacer()
                    
                    Button {
                        if let url = URL(string: app.appUrl ?? "") {
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
                
                Text(app.description ?? "")
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
