//
//  ShootsApp.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/14.
//

import SwiftUI

@main
struct ShootsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        
        #if os(macOS)
        MenuBarExtra("Status", systemImage: "photo.fill.on.rectangle.fill") {
            MenuBarExtraView()
                .frame(width: 520, height: 600)
        }.menuBarExtraStyle(.window)
        
        Settings {
            SettingView()
                .padding(36)
                .sheetFrameForMac()
        }
        #endif
    }
}
