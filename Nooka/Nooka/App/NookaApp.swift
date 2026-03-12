//
//  NookaApp.swift
//  Nooka
//
//  Created by Nooka on 2024.
//

import SwiftUI

@main
struct NookaApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
