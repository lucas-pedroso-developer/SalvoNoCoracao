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
        // Botão Voltar: seta azul e sem texto
        UINavigationBar.appearance().backIndicatorImage = UIImage(systemName: "chevron.left")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.left")
        UIBarButtonItem.appearance().setTitleTextAttributes([:], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([:], for: .highlighted)
        UINavigationBar.appearance().tintColor = UIColor.systemBlue
        
        // SegmentedControl azul (iOS 16)
        UISegmentedControl.applyBlueTint()
    }

    var body: some Scene {
        WindowGroup {
            AppRootView()              // 👈 aqui em vez de RootView()
                .environmentObject(coordinator)
        }
    }
//    var body: some Scene {
//        WindowGroup {
//            RootView()
//                .environmentObject(coordinator)
//                .tint(.blue)
//        }
//    }
}
