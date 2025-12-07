//
//  VerseOfTheDayView.swift
//  Salvo no Coracao
//
//  Created by Lucas Pedroso on 26/11/25.
//

import SwiftUI

struct VerseOfTheDayView: View {
    @StateObject var viewModel: VerseOfTheDayViewModel
    let memorizedStore: MemorizedVersesStore
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                subtitleView()
                    .padding(.top, 24)

                progressView()

                contentByState()

                refreshButton()
                Spacer().frame(height: 32)
            }
        }
        .navigationTitle("Salvo no Coração")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                mainMenu
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                if let verse = viewModel.currentVerse {
                    ShareLink(
                        item: shareText(for: verse)
                    ) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
        .onAppear {
            if case .idle = viewModel.state {
                viewModel.load()
            }
        }
    }

    // MARK: - State → UI

    @ViewBuilder
    private func contentByState() -> some View {
        switch viewModel.state {
        case .idle, .loading:
            loadingView

        case .loaded(let verse):
            VStack(spacing: 8) {
                verseCard(verse)
                memorizedBadge(for: verse)
            }

        case .error(let message):
            errorView(message: message)
        }
    }

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
            Text("Carregando versículo...")
                .font(.callout.weight(.medium))
                .foregroundColor(.gray.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 40)
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Text("Ops…")
                .font(.headline)

            Text(message)
                .font(.callout)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)

            Button {
                viewModel.load()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.clockwise")
                    Text("Tentar novamente")
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.blue.opacity(0.1))
                .clipShape(Capsule())
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 32)
        .padding(.top, 40)
    }

    // MARK: - Subviews existentes

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

    private func verseCard(_ verse: Verse) -> some View {
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
    
    fileprivate func card(verse: Verse) -> some View {
        VStack(spacing: 20) {
            icon()
            verseContainer(verse: verse)
            buttons(verse: verse)
        }
        .padding(24)
    }
    
    fileprivate func buttons(verse: Verse) -> some View {
        HStack(spacing: 16) {
            Button(action: {
                coordinator.showMemorize(for: verse)
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

    private func memorizedBadge(for verse: Verse) -> some View {
        let isMemorized = memorizedStore.isMemorized(id: verse.id)

        return HStack(spacing: 6) {
            Image(systemName: isMemorized ? "checkmark.seal.fill" : "seal")
                .font(.subheadline)
                .foregroundColor(isMemorized ? .green : .secondary)

            Text(isMemorized ? "Versículo memorizado" : "Ainda não memorizado")
                .font(.footnote.weight(.medium))
                .foregroundColor(isMemorized ? .green : .secondary)
        }
        .padding(.top, 8)
    }

    private func shareText(for verse: Verse) -> String {
        """
        \(verse.reference)

        \(verse.text)

        — Enviado pelo app Salvo no Coração
        """
    }

    private var mainMenu: some View {
        Menu {
            Button {
                coordinator.showFavorites()
            } label: {
                Label("Favoritos", systemImage: "star.fill")
            }

            Button {
                coordinator.go(to: .themes)
            } label: {
                Label("Versículos por tema", systemImage: "list.bullet")
            }

            Button {
                coordinator.showCredits()
            } label: {
                Label("Sobre & créditos", systemImage: "info.circle")
            }

            Button {
                coordinator.showMemorized()
            } label: {
                Label("Versículos memorizados", systemImage: "checkmark.seal")
            }
        } label: {
            Image(systemName: "line.3.horizontal")
                .font(.headline)
                .padding(4)
        }
    }
    
    private func progressView() -> some View {
        let total = viewModel.totalVersesCount
        let memorized = viewModel.totalMemorizedCount(using: memorizedStore)

        guard total > 0 else { return AnyView(EmptyView()) }

        let progress = Double(memorized) / Double(total)

        return AnyView(
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Progresso de memorização")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.primary)

                    Spacer()

                    Text("\(memorized) de \(total)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 999)
                            .fill(Color.gray.opacity(0.2))

                        RoundedRectangle(cornerRadius: 999)
                            .fill(Color.blue.opacity(0.9))
                            .frame(width: geometry.size.width * CGFloat(progress))
                    }
                }
                .frame(height: 8)
            }
            .padding(.horizontal, 20)
        )
    }

}

#Preview {
    let repository = LocalJSONVerseRepository()
    let favoritesStore = UserDefaultsFavoritesStore()
    let viewModel = VerseOfTheDayViewModel(
        repository: repository,
        favoritesStore: favoritesStore
    )
    
    let coordinator = AppCoordinator()
    
    return NavigationStack {
        VerseOfTheDayView(
            viewModel: viewModel,
            memorizedStore: UserDefaultsMemorizedVersesStore()
        )
        .environmentObject(coordinator)
    }
    .preferredColorScheme(.dark)
}
