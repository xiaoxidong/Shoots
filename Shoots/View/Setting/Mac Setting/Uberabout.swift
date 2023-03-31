

import SwiftUI
#if os(macOS)
import Cocoa
#endif
import os.log

struct Uberabout {
    
    static let windowWidth: CGFloat = 268.0
    static let windowHeight: CGFloat = 348.0
    
    static func aboutWindow(for bundle: Bundle = Bundle.main) -> NSWindow {
        
        let origin = CGPoint.zero
        let size = CGSize(width: self.windowWidth, height: self.windowHeight)
        
        let window = NSWindow(contentRect: NSRect(origin: origin, size: size),
                              styleMask: [.titled, .closable, .fullSizeContentView],
                              backing: .buffered,
                              defer: false)
        
        window.setFrameAutosaveName(bundle.appName)
        window.setAccessibilityTitle(bundle.appName)
        window.titlebarAppearsTransparent = true
        window.isMovableByWindowBackground = true
        window.isReleasedWhenClosed = false
        
        // Configure here
        let aboutView = UberaboutView(bundle: bundle,
                                      appIconBackside: Image("uberaboutIconBack"),
                                      creditsURL: "http://productpoke.com",
                                      organizationLogo: Image("uberaboutOrgaLogo"))
        
        window.contentView = NSHostingView(rootView: aboutView)
        window.center()
        
        return window
        
    }
    
}


// MARK: - About View
struct UberaboutView: View {
    
    let bundle: Bundle
    var appIconBackside: Image? = nil // 128pt × 128pt
    var creditsURL: String? = nil
    var organizationLogo: Image? = nil // 12pt height max & render as template
    
    private let windowWidth: CGFloat = Uberabout.windowWidth
    private let windowHeight: CGFloat = Uberabout.windowHeight
    
    @State private var iconHover: Bool = false
    @State private var foregroundIconVisible: Bool = true
    @State private var backgroundIconVisible: Bool = false
    @State private var copyrightFlipped: Bool = false
    @State var showPrivacy = false
    @State var showAgreement = false
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                HStack(alignment: .top) {
                    icon.padding(.top, 36).padding(.leading, 26)
                    
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
            icon
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
    
    var icon: some View {
        ZStack {
            // App Icon: Back
            Group {
                if let backside = self.appIconBackside {
                    backside.resizable()
                } else {
                    AppIconPlaceholder()
                }
            }
            .rotation3DEffect(self.backgroundIconVisible ? Angle.zero : Angle(degrees: -90.0),
                              axis: (x: 0.0, y: 1.0, z: 0.0),
                              anchor: .center,
                              anchorZ: 0.0,
                              perspective: -0.5)
            
            // App Icon: Front
            Group {
                if let appIcon = NSApp.applicationIconImage {
                    Image(nsImage: appIcon)
                } else {
                    AppIconPlaceholder()
                }
            }
            .rotation3DEffect(self.foregroundIconVisible ? Angle.zero : Angle(degrees: 90.0),
                              axis: (x: 0.0, y: 1.0, z: 0.0),
                              anchor: .center,
                              anchorZ: 0.0,
                              perspective: -0.5)
            
        }
        .frame(width: 128.0, height: 128.0)
        .brightness(self.iconHover ? 0.05 : 0.0)
        .onHover(perform: {
            state in
            
            let ani = Animation.easeInOut(duration: 0.16)
            withAnimation(ani, {
                self.iconHover = state
            })
            
            if !state && self.backgroundIconVisible {
                self.flipIcon()
            }
            
        })
        .onTapGesture(perform: {
            self.flipIcon()
        })
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
    
    
    private func flipIcon() {
        
        let reversed = self.foregroundIconVisible
        
        let inDuration = 0.12
        let inAnimation = Animation.easeIn(duration: inDuration)
        let outAnimation = Animation.easeOut(duration: 0.32)
        
        withAnimation(inAnimation, {
            if reversed {
                self.foregroundIconVisible.toggle()
            } else {
                self.backgroundIconVisible.toggle()
            }
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + inDuration) {
            withAnimation(outAnimation, {
                if !reversed {
                    self.foregroundIconVisible.toggle()
                } else {
                    self.backgroundIconVisible.toggle()
                }
            })
        }
        
    }
    
    
}


// MARK: - App Icon Placeholder
struct AppIconPlaceholder: View {
    private let cornerSize: CGSize = CGSize(width: 24.0, height: 24.0)
    var body: some View {
        return RoundedRectangle(cornerSize: self.cornerSize, style: .continuous)
            .foregroundColor(Color.secondary)
            .padding(13.0)
    }
}


// MARK: - Button Style
fileprivate struct UberaboutWindowButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        let color = Color.accentColor
        let pressed = configuration.isPressed
        return configuration.label
            .font(Font.body.weight(.medium))
            .padding([.leading, .trailing], 8.0)
            .padding([.top], 4.0)
            .padding([.bottom], 5.0)
            .background(color.opacity(pressed ? 0.08 : 0.14))
            .foregroundColor(color.opacity(pressed ? 0.8 : 1.0))
            .cornerRadius(5.0)
    }
}

// MARK: - Preview
struct UberaboutView_Previews: PreviewProvider {
    static var previews: some View {
        return UberaboutView(bundle: Bundle.main,
                             appIconBackside: Image("uberaboutIconBack"),
                             creditsURL: "http://ixeau.com",
                             organizationLogo: Image("uberaboutOrgaLogo"))
    }
}
