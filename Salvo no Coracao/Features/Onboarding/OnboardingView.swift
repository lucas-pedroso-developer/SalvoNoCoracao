//
//  OnboardingView.swift
//  Salvo no Coracao
//
//  Created by Lucas Pedroso on 07/12/25.
//

import SwiftUI

struct OnboardingView: View {
    let onFinish: () -> Void

    @State private var currentIndex = 0

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            imageSystemName: "book.fill",
            title: "Guarde a Palavra no coração",
            subtitle: "Todo dia você recebe um versículo selecionado para meditar e fortalecer sua fé."
        ),
        OnboardingPage(
            imageSystemName: "star.fill",
            title: "Favoritar e memorizar",
            subtitle: "Salve os versículos que falaram com você e use o modo de memorização para decorar a Bíblia com calma."
        ),
        OnboardingPage(
            imageSystemName: "checkmark.seal.fill",
            title: "Acompanhe seu progresso",
            subtitle: "Veja quantos versículos já memorizou e avance um passo de cada vez na sua jornada com Deus."
        )
    ]

    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()

            VStack {
                TabView(selection: $currentIndex) {
                    ForEach(pages.indices, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))

                bottomBar
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
            }
        }
    }

    private var isLastPage: Bool {
        currentIndex == pages.count - 1
    }

    private var bottomBar: some View {
        HStack {
            Button {
                onFinish()
            } label: {
                Text("Pular")
                    .font(.body)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Button {
                if isLastPage {
                    onFinish()
                } else {
                    withAnimation {
                        currentIndex += 1
                    }
                }
            } label: {
                HStack(spacing: 8) {
                    Text(isLastPage ? "Começar" : "Próximo")
                        .font(.body.weight(.semibold))

                    Image(systemName: isLastPage ? "checkmark" : "chevron.right")
                        .font(.body.weight(.semibold))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
        }
    }
}
