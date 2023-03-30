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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    #if os(macOS)
                    NSApp.activate(ignoringOtherApps: true)
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
                }
                .onDisappear {
//                    NSApp.setActivationPolicy(.prohibited)
                }
        }
        
        MenuBarExtra("Status", systemImage: "photo.fill.on.rectangle.fill", isInserted: $isInserted) {
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
