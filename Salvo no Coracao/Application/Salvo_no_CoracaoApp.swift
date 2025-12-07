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
        UINavigationBar.appearance().backIndicatorImage = UIImage(systemName: "chevron.left")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.left")
        UIBarButtonItem.appearance().setTitleTextAttributes([:], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([:], for: .highlighted)
        UINavigationBar.appearance().tintColor = UIColor.systemBlue
        UISegmentedControl.applyBlueTint()
    }
    
    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environmentObject(coordinator)
        }
    }
}
