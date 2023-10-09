//
//  ShootsApp.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/14.
//

import SwiftUI
import Diagnostics
#if os(macOS)
import MASShortcut
#endif

@main
struct ShootsApp: App {
    init() {
        setUp()
    }

    @State var isInserted = true
    @State var isMenuPresented: Bool = false
    @AppStorage("statusIcon") var statusIcon: String = "photo.fill.on.rectangle.fill"

    @AppStorage("colorMode") private var colorMode: ShootColorScheme = .none
    @Environment(\.colorScheme) var colorScheme

    var body: some Scene {
        WindowGroup(id: "sa") {
            content
                .onAppear {
                    #if os(macOS)
                        NSApp.activate(ignoringOtherApps: true)
                        NotificationCenter.default.addObserver(forName: NSWindow.willCloseNotification, object: nil, queue: .main) { _ in
                            // 关闭窗口的时候，隐藏应用
                            // 由于设置里的下拉，也是窗口，不加这个判断会点击下拉关闭的时候会把窗口关闭，希望后续能有更好的解决办法。
                            //                            if NSApplication.shared.windows.count < 6 {
                            //                                NSApp.setActivationPolicy(.prohibited)
                            //                            }
                            // NSApp.setActivationPolicy(.prohibited)
                            NSApp.setActivationPolicy(.prohibited)
                        }
                        configureShortcuts()
                    
                    setNewWindow()
                    #endif
                }
        }

        #if os(macOS)
            Window("Shoots", id: "main") {
                content
                    .onAppear {
                        if let window = NSApplication.shared.windows.first, window.className == "SwiftUI.AppKitWindow" {
                            window.close()
                        }
                    }
                    .onReceive(NotificationCenter.default.publisher(for: NSApplication.willBecomeActiveNotification)) { _ in
                        NSApp.setActivationPolicy(.regular)
                    }
                    .onReceive(NotificationCenter.default.publisher(for: NSApplication.willResignActiveNotification)) { _ in
                        NSApp.setActivationPolicy(.prohibited)
                    }
            }

//        SidebarCommands()
//        TextEditingCommands()
//        TextFormattingCommands()
//        ToolbarCommands()
            MenuBarExtra("Status", systemImage: statusIcon, isInserted: $isInserted) {
                MenuBarExtraView(isInserted: $isInserted, isMenuPresented: $isMenuPresented)
                    .frame(width: 520, height: 600)
                    .environmentObject(user)
                    .environmentObject(info)
                    .environmentObject(search)
                    .preferredColorScheme(colorScheme)
                    .preferredColorScheme(colorMode.colorScheme)
            }.menuBarExtraStyle(.window)
                .menuBarExtraAccess(isPresented: $isMenuPresented)

            Settings {
                MacSettingsView()
                    .environmentObject(user)
            }
        #endif
    }

    @StateObject var user: UserViewModel = .init()
    @StateObject var info: InfoViewModel = .init()
    @StateObject var search: SearchViewModel = .init()
    var content: some View {
        Group {
            #if os(iOS)
            ContentView()
            #else
            ContentView()
            #endif
        }.frame(minWidth: 400, idealWidth: 800, maxWidth: .infinity, minHeight: 300, idealHeight: 600, maxHeight: .infinity)
        .environmentObject(user)
        .environmentObject(info)
        .environmentObject(search)
        .preferredColorScheme(colorScheme)
        .preferredColorScheme(colorMode.colorScheme)
    }

    #if os(macOS)
        // 快捷键启动状态栏搜索
        // https://github.com/shpakovski/MASShortcut.git
        private func configureShortcuts() {
            let activeShortcut = MASShortcut(keyCode: kVK_ANSI_S, modifierFlags: [.command, .control])

            MASShortcutMonitor.shared().register(activeShortcut, withAction: {
                isMenuPresented = true
            })
        }
    #endif
    
    @AppStorage("showNew") var showNew: Bool = true
    func setNewWindow() {
        if showNew {
            
        }
    }

    func setUp() {
        // 内购
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                @unknown default:
                    fatalError()
                }
            }
        }
        
        do {
            try DiagnosticsLogger.setup()
        } catch {
            print("Failed to setup the Diagnostics Logger")
        }
    }
}
