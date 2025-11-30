//
//  Salvo_no_CoracaoApp.swift
//  Salvo no Coracao
//
//  Created by Lucas Pedroso on 26/11/25.
//

import SwiftUI

@main
struct SalvoNoCoracaoApp: App {
    @StateObject private var coordinator = AppCoordinator()
    
    init() {
        UISegmentedControl.applyBlueTint()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(coordinator)
                .tint(.blue)
        }
    }
}
