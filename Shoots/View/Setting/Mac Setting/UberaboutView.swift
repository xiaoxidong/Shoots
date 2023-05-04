//
//  UberaboutView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/4/3.
//

import SwiftUI

struct UberaboutView: View {
    let bundle: Bundle
    var creditsURL: String? = nil
    var organizationLogo: Image? = nil
    @State private var copyrightFlipped: Bool = false
    @State var showPrivacy = false
    @State var showAgreement = false
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                HStack(alignment: .top) {
                    AppIconView(appIconBackside: Image("uberaboutIconBack"), appIconFrontside: Image("uberaboutIconBack"))
                        .padding(.top, 36)
                        .padding(.leading, 26)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(alignment: .firstTextBaseline) {
                                // App Name
                                Text(Bundle.appName)
                                    .font(Font.largeTitle.weight(.semibold))
                                
                                // App Version & Build
                                HStack(spacing: 4.0) {
                                    let versionSuffix = NSLocalizedString("Version",  bundle: self.bundle, comment: "")
                                    Text("\(versionSuffix)\u{00a0}\(Bundle.appVersionMarketing)")
                                        .font(Font.body.weight(.medium))
                                        .foregroundColor(.secondary)
                                    
                                    Text("(\(Bundle.appVersionBuild))")
                                        .font(Font.body.monospacedDigit().weight(.regular))
                                        .foregroundColor(.secondary)
                                        .opacity(0.7)
                                }
                            }
                            Text(Bundle.copyrightHumanReadable)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .opacity(0.7)
                        }.padding(.top, 36)
                        
                        Divider().padding(.trailing, 36)
                        about
                        Divider().padding(.trailing, 36)
                        Text("更多应用")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .padding(.top, 16)
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }
                
                VStack(alignment: .leading, spacing: 36) {
                    appsView(name: "Poke", content: "A simple but highly customizable UICollectionViewLayout for UICollectionView -- Simple SwiftUI views that let you make page-view effects.", image: "", url: "")
                    appsView(name: "Poke", content: "A simple but highly customizable UICollectionViewLayout for UICollectionView -- Simple SwiftUI views that let you make page-view effects.", image: "", url: "")
                    appsView(name: "Poke", content: "A simple but highly customizable UICollectionViewLayout for UICollectionView -- Simple SwiftUI views that let you make page-view effects.", image: "", url: "")
                }.padding(.bottom, 36)
            }
            
            bottomView
        }
        .sheet(isPresented: self.$showAgreement) {
            AgreementView(showAgreement: $showAgreement)
                .sheetFrameForMac()
        }
        .sheet(isPresented: self.$showPrivacy) {
            PrivacyView(showPrivacy: self.$showPrivacy)
                .sheetFrameForMac()
        }
    }
    
    func appsView(name: String, content: String, image: String, url: String) -> some View {
        HStack(alignment: .top) {
            AppIconView(appIconBackside: Image("uberaboutIconBack"), appIconFrontside: Image("uberaboutIconBack"))
            VStack(alignment: .leading, spacing: 12) {
                Text(name)
                    .font(.largeTitle)
                    .bold()
                Text(content)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.secondary)
                    .lineSpacing(4)
                
                Button {
                    
                } label: {
                    Label("应用下载", systemImage: "apple.logo")
                }.buttonStyle(UberaboutWindowButtonStyle())
            }
        }.padding(.horizontal, 26)
    }
    
    var about: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("团队")
                .font(.body)
            
            HStack {
                Text("设计师：")
                    .font(.body)
                
                Button {
                    
                } label: {
                    Text("Xiaodong")
                }.buttonStyle(UberaboutWindowButtonStyle())
            }
            
            HStack {
                Text("开发者：")
                    .font(.body)
                
                Button {
                    
                } label: {
                    Text("Xiaodong")
                }.buttonStyle(UberaboutWindowButtonStyle())
            }
        }
    }
    
    var bottomView: some View {
        VStack(spacing: 0) {
            Divider()

            HStack(spacing: 12) {
                Button(action: {
                    let url = URL(string: "https://productpoke.notion.site/Poke-fb2377abed624b189677b74d06618f11")!
                    NSWorkspace.shared.open(url)
                }, label: {
                    Label(title: {
                        Text("Shoots 官网")
                    }, icon: {
                        Image(systemName: "book.closed.circle.fill")
                    })
                    .lineLimit(1)
                })
                .buttonStyle(UberaboutWindowButtonStyle())

                Spacer()
                
                Button {
                    showPrivacy.toggle()
                } label: {
                    Text("隐私协议")
                }
                
                Button {
                    showAgreement.toggle()
                } label: {
                    Text("使用条款")
                }
                
            }.padding(.horizontal)
            .font(Font.footnote)
            .foregroundColor(.secondary)
            .padding([.top], 12.0)
            .padding([.bottom], 14.0)
            .background(Color.primary.opacity(0.03))
            .onHover(perform: {
                state in
                let ani = Animation.easeInOut(duration: 0.16)
                withAnimation(ani, {
                    self.copyrightFlipped = state
                })
            })
        }
    }
}

struct UberaboutView_Previews: PreviewProvider {
    static var previews: some View {
        UberaboutView(bundle: Bundle.main)
            .previewDisplayName("Chinese")
            .environment(\.locale, .init(identifier: "zh-cn"))
        
        UberaboutView(bundle: Bundle.main)
            .previewDisplayName("English")
            .environment(\.locale, .init(identifier: "en"))
    }
}
