//
//  AlbumerApp.swift
//  Albumer
//
//  Created by Marjan Khodadad on 9/20/22.
//

import SwiftUI

@main
struct AlbumerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
