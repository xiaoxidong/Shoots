//
//  ShootsApp.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/14.
//

import SwiftUI

@main
struct ShootsApp: App {
    @State var isInserted = true
    @State var isMenuPresented: Bool = false
    @AppStorage("statusIcon") var statusIcon: String = "photo.fill.on.rectangle.fill"
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    #if os(macOS)
                    NSApp.activate(ignoringOtherApps: true)
                    NotificationCenter.default.addObserver(forName: NSWindow.willCloseNotification, object: nil, queue: .main) { app in
                        // 关闭窗口的时候，隐藏应用
                        // 由于设置里的下拉，也是窗口，不加这个判断会点击下拉关闭的时候会把窗口关闭，希望后续能有更好的解决办法。
                        if NSApplication.shared.windows.count < 6 {
                            NSApp.setActivationPolicy(.prohibited)
                        }
                        
                    }
                    #endif
                }
        }
        
        #if os(macOS)
        Window("Shoots", id: "main") {
            ContentView()
                .onAppear {
                    if let window = NSApplication.shared.windows.first, window.className == "SwiftUI.AppKitWindow" {
                        window.close()
                    }
                    NotificationCenter.default.addObserver(forName: NSApplication.willTerminateNotification, object: nil, queue: .main) { _ in
                        print("--------")
                    }
                }
                .onDisappear {
//                    NSApp.setActivationPolicy(.prohibited)
                }
        }
        
        MenuBarExtra("Status", systemImage: statusIcon, isInserted: $isInserted) {
            MenuBarExtraView(isInserted: $isInserted, isMenuPresented: $isMenuPresented)
                .frame(width: 520, height: 600)
        }.menuBarExtraStyle(.window)
            .menuBarExtraAccess(isPresented: $isMenuPresented)
        
        Settings {
            MacSettingsView()
        }
        #endif
    }
}
