//
//  ThemeDetailView.swift
//  Salvo no Coracao
//
//  Created by Lucas Pedroso on 06/12/25.
//

import SwiftUI

struct ThemeDetailView: View {
    let theme: VerseTheme

    private var verses: [ThemeVerse] {
        switch theme {
        case .ansiedade:
            return [
                ThemeVerse(
                    reference: "Filipenses 4:6-7",
                    text: "Não andem ansiosos por coisa alguma, mas em tudo, pela oração e súplicas, e com ação de graças, apresentem seus pedidos a Deus. E a paz de Deus, que excede todo entendimento, guardará o coração e a mente de vocês em Cristo Jesus."
                ),
                ThemeVerse(
                    reference: "1 Pedro 5:7",
                    text: "Lancem sobre ele toda a sua ansiedade, porque ele tem cuidado de vocês."
                )
            ]

        case .tristeza:
            return [
                ThemeVerse(
                    reference: "Salmo 34:18",
                    text: "Perto está o SENHOR dos que têm o coração quebrantado e salva os de espírito oprimido."
                ),
                ThemeVerse(
                    reference: "Salmo 30:5",
                    text: "O choro pode durar uma noite, mas a alegria vem pela manhã."
                )
            ]

        case .medo:
            return [
                ThemeVerse(
                    reference: "Isaías 41:10",
                    text: "Não temas, porque eu sou contigo; não te assombres, porque eu sou o teu Deus; eu te fortaleço, e te ajudo, e te sustento com a destra da minha justiça."
                ),
                ThemeVerse(
                    reference: "Salmo 56:3",
                    text: "Em me vindo o temor, hei de confiar em ti."
                )
            ]

        case .solidao:
            return [
                ThemeVerse(
                    reference: "Salmo 27:10",
                    text: "Mesmo que meu pai e minha mãe me abandonem, o SENHOR me acolherá."
                ),
                ThemeVerse(
                    reference: "Mateus 28:20",
                    text: "E eis que estou convosco todos os dias, até a consumação dos séculos."
                )
            ]

        case .esperanca:
            return [
                ThemeVerse(
                    reference: "Romanos 15:13",
                    text: "Que o Deus da esperança os encha de toda alegria e paz, por sua confiança nele, para que vocês transbordem de esperança, pelo poder do Espírito Santo."
                ),
                ThemeVerse(
                    reference: "Lamentações 3:21-23",
                    text: "Quero trazer à memória o que me pode dar esperança. As misericórdias do SENHOR são a causa de não sermos consumidos, porque as suas misericórdias não têm fim; renovam-se cada manhã."
                )
            ]

        case .gratidao:
            return [
                ThemeVerse(
                    reference: "1 Tessalonicenses 5:18",
                    text: "Em tudo dai graças, porque esta é a vontade de Deus em Cristo Jesus para convosco."
                ),
                ThemeVerse(
                    reference: "Salmo 103:2",
                    text: "Bendize, ó minha alma, ao SENHOR, e não te esqueças de nenhum de seus benefícios."
                )
            ]

        case .forca:
            return [
                ThemeVerse(
                    reference: "Isaías 40:31",
                    text: "Mas os que esperam no SENHOR renovam as suas forças, sobem com asas como águias; correm e não se cansam, caminham e não se fatigam."
                ),
                ThemeVerse(
                    reference: "2 Coríntios 12:9",
                    text: "A minha graça te basta, porque o meu poder se aperfeiçoa na fraqueza."
                )
            ]
        }
    }

    @State private var selectedVerse: ThemeVerse?
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(theme.title)
                        .font(.largeTitle.weight(.bold))
                        .padding(.top, 24)

                    Text(theme.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 8)

                    ForEach(verses) { verse in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(verse.reference)
                                .font(.headline)
                                .foregroundColor(.blue)

                            Text(verse.text)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.leading)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(18)
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                    }

                    Spacer(minLength: 16)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    coordinator.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    NavigationStack {
        ThemeDetailView(theme: .ansiedade)
    }
}
