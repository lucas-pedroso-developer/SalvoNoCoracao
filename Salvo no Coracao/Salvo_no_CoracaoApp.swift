//
//  Salvo_no_CoracaoApp.swift
//  Salvo no Coracao
//
//  Created by Lucas Pedroso on 26/11/25.
//

import SwiftUI
import CoreData

@main
struct Salvo_no_CoracaoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
