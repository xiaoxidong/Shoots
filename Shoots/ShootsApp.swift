//
//  ShootsApp.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/2/23.
//

import SwiftUI

@main
struct ShootsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
