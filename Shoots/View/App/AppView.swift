//
//  AppView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/20.
//

import SDWebImageSwiftUI
import SwiftUI

struct AppView: View {
    var id: String
    var appID: String?
    var topPadding: CGFloat = 0

    @StateObject var app: AppViewModel = .init()
    @EnvironmentObject var user: UserViewModel
    
    @State var selection: Int = 1
    @State var showVip = false
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                header
                if !app.flows.isEmpty {
                    flowView
                }
                
                if !user.isPro {
                    Text("小课堂")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.shootBlack)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                        .padding(.bottom)
                        .padding(.top, 26)
                    
                    new
                }
                
                HStack(spacing: 12) {
                    if user.isPro {
                        Button {
                            withAnimation(.spring()) {
                                selection = 0
                            }
                        } label: {
                            Text("小课堂")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(selection == 0 ? .shootBlue : .shootBlack)
                        }.buttonStyle(.plain)
                            .onAppear {
                                withAnimation(.spring()) {
                                    selection = 0
                                }
                            }
                    }
                    Button {
                        withAnimation(.spring()) {
                            selection = 1
                        }
                        #if DEBUG
                        user.isPro = true
                        #endif
                    } label: {
                        Text("应用截图")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(selection == 1 && user.isPro ? .shootBlue : .shootBlack)
                    }.buttonStyle(.plain)
                    Spacer()
                }.animation(nil, value: selection)
                    .padding(.leading)
                    .padding(.bottom)
                    .padding(.top, 26)
                
                if selection == 1 {
                    imagesView
                } else {
                    TitleFeedView(shoots: pic)
                }
            }.frame(maxWidth: 860)
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
            .sheet(isPresented: $showVip) {
                ProView()
            }
    }
    var new: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(1...6, id: \.self) { index in
                    Image("s\(index)")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 260)
                        .overlay(alignment: .topTrailing) {
                            Image(["gif", "new"].randomElement()!)
                                .padding(6)
                        }
                }
                
                Color.shootGray
                    .opacity(0.1)
                    .frame(width: 160)
                    .overlay(
                        VStack(spacing: 12) {
                            Image(systemName: "music.quarternote.3")
                            Text("查看更多内容")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.shootGray)
                        }
                    )
                    .onTapGesture {
                        showVip.toggle()
                    }
                
            }.padding([.horizontal])
        }
    }

    func loadData() async {
        if let appID = appID {
            await app.info(id: appID)
        }

        await app.getAppDetail(id: id) { _ in
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

    @ViewBuilder
    var imagesView: some View {
        if app.loading {
            LoadingView()
                .frame(height: 360)
        } else {
            if app.appFeed.isEmpty {
                ShootEmptyView()
                    .frame(height: 360)
            } else {
                FeedView(shoots: app.appFeed)
                LoadMoreView(footerRefreshing: $app.footerRefreshing, noMore: $app.noMore) {
                    Task {
                        await app.nextPage(id: id)
                    }
                }
            }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AppView(id: "", appID: "6446901002")
        }
        .previewDisplayName("Chinese")
        .environmentObject(UserViewModel())
        .environment(\.locale, .init(identifier: "zh-cn"))

        NavigationView {
            AppView(id: "", appID: "6446901002")
        }
        .previewDisplayName("English")
        .environmentObject(UserViewModel())
        .environment(\.locale, .init(identifier: "en"))
    }
}
