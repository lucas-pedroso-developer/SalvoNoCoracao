//
//  VerseOfTheDayView.swift
//  Salvo no Coracao
//
//  Created by Lucas Pedroso on 26/11/25.
//

import SwiftUI
import Combine

struct VerseOfTheDayView: View {
    @StateObject var viewModel: VerseOfTheDayViewModel
    @State private var showFavorites = false
    @State private var showMemorize = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    subtitleView()
                        .padding(.top, 24)

                    if let verse = viewModel.currentVerse {
                        ZStack(alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 28)
                                .fill(.ultraThinMaterial)
                                .shadow(
                                    color: .black.opacity(0.08),
                                    radius: 16,
                                    x: 0,
                                    y: 8
                                )

                            card(verse: verse)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 4)
                    }

                    refreshButton()
                    Spacer().frame(height: 32)
                }
            }
            .navigationTitle("Salvo no Coração")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showFavorites = true
                    } label: {
                        Image(systemName: "star.circle.fill")
                            .font(.title3.weight(.semibold))
                            .foregroundColor(.blue)
                    }
                    .accessibilityLabel("Abrir favoritos")
                }
            }
            .toolbarBackground(.white, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
            .sheet(isPresented: $showMemorize) {
                if let verse = viewModel.currentVerse {
                    MemorizeView(viewModel: MemorizeViewModel(verse: verse))
                }
            }
            .sheet(isPresented: $showFavorites) {
                FavoritesView(viewModel: FavoritesViewModel(verseOfTheDayViewModel: viewModel))
            }
            .onAppear {
                viewModel.load()
            }
        }
    }

    fileprivate func subtitleView() -> some View {
        Text("VERSÍCULO DO DIA")
            .font(.footnote.weight(.semibold))
            .foregroundColor(.gray.opacity(0.8))
            .tracking(1)
    }

    fileprivate func refreshButton() -> some View {
        Button {
            viewModel.refreshRandom()
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "arrow.clockwise")
                    .font(.body.weight(.medium))

                Text("Trocar versículo")
                    .font(.body)
            }
            .foregroundColor(.gray)
            .padding(.top, 4)
        }
        .accessibilityLabel("Trocar versículo do dia")
        .accessibilityHint("Escolhe outro versículo aleatório para hoje.")
    }

    fileprivate func card(verse: Verse) -> some View {
        VStack(spacing: 20) {
            icon()
            verseContainer(verse: verse)
            buttons()
        }
        .padding(24)
    }

    fileprivate func buttons() -> some View {
        HStack(spacing: 16) {
            Button(action: {
                showMemorize = true
            }) {
                Text("Memorizar")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.body.weight(.semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .allowsTightening(true)
                    .clipShape(Capsule())
            }
            .accessibilityLabel("Memorizar versículo do dia")
            .accessibilityHint("Abre a tela para treinar a memorização deste versículo.")

            Button(action: {
                viewModel.toggleFavorite()
            }) {
                HStack(spacing: 6) {
                    Image(systemName: viewModel.isFavorite ? "star.fill" : "star")
                    Text("Favoritar")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .padding(.horizontal, 12)
                .background(Color.gray.opacity(0.15))
                .foregroundColor(.blue)
                .font(.body.weight(.semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .allowsTightening(true)
                .clipShape(Capsule())
            }
            .accessibilityLabel(
                viewModel.isFavorite
                ? "Remover dos favoritos"
                : "Adicionar aos favoritos"
            )
            .accessibilityHint("Salva o versículo na sua lista de favoritos.")
        }
        .padding(.horizontal, 16)
    }
    
    fileprivate func icon() -> some View {
        HStack {
            Image(systemName: "book.fill")
                .font(.title3)
                .foregroundColor(.gray.opacity(0.4))
                .padding(.leading, 4)
                .padding(.top, 4)
            
            Spacer()
        }
    }
    
    fileprivate func verseContainer(verse: Verse) -> some View {
        VStack(spacing: 12) {
            Text(verse.reference)
                .font(.title2.weight(.bold))
                .foregroundColor(.primary)

            Text(verse.text)
                .font(.system(.title3, design: .serif))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}

#Preview {
    let repository = LocalJSONVerseRepository()
    let favoritesStore = UserDefaultsFavoritesStore()

    let viewModel = VerseOfTheDayViewModel(
        repository: repository,
        favoritesStore: favoritesStore
    )
    
    return VerseOfTheDayView(viewModel: viewModel).preferredColorScheme(.dark)
}
