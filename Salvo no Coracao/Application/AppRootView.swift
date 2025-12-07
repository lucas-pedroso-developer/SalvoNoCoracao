//
//  AppRootView.swift
//  Salvo no Coracao
//
//  Created by Lucas Pedroso on 07/12/25.
//

import SwiftUI

struct AppRootView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var showSplash = true

    var body: some View {
        ZStack {
            if showSplash {
                SplashView()
                    .transition(.opacity)
            } else {
                RootView() // 👈 sua RootView atual, do jeito que está
                    .transition(.opacity)
            }
        }
        .onAppear {
            // tempo da splash (ajusta se quiser)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                withAnimation(.easeOut(duration: 0.5)) {
                    showSplash = false
                }
            }
        }
    }
}
