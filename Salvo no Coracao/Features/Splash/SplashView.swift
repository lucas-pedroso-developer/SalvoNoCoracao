//
//  SplashView.swift
//  Salvo no Coracao
//
//  Created by Lucas Pedroso on 07/12/25.
//

import SwiftUI

struct SplashView: View {
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.0

    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Image(systemName: "heart.text.square.fill")
                    .font(.system(size: 64))
                    .foregroundColor(.blue)

                Text("Salvo no Coração")
                    .font(.title.weight(.bold))
                    .foregroundColor(.primary)

                Text("Guardando a Palavra dia após dia")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .scaleEffect(scale)
            .opacity(opacity)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.7)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
}
