//
//  VerseOfTheDayViewModel.swift
//  Salvo no Coracao
//
//  Created by Lucas Pedroso on 26/11/25.
//

import Foundation
import SwiftUI
import Combine
import StoreKit

@MainActor
final class VerseOfTheDayViewModel: ObservableObject {
    @Published private(set) var currentVerse: Verse?
    @Published private(set) var isFavorite: Bool = false
    @Published private(set) var state: VerseOfTheDayState = .idle   // 👈 NOVO

    private let repository: VerseRepository
    private let favoritesStore: FavoritesStore

    private var allVerses: [Verse] = []
    private var favoriteIDs: Set<String> = []

    init(repository: VerseRepository, favoritesStore: FavoritesStore) {
        self.repository = repository
        self.favoritesStore = favoritesStore
    }

    func load() {
        state = .loading

        do {
            allVerses = try repository.loadVerses()
            favoriteIDs = favoritesStore.loadFavoriteIDs()
            selectVerseOfTheDay()
        } catch {
            print("Erro ao carregar versículos: \(error)")
            currentVerse = nil
            isFavorite = false
            state = .error(
                "Não foi possível carregar o versículo agora. Tente novamente mais tarde."
            )
        }
    }

    private func selectVerseOfTheDay() {
        guard !allVerses.isEmpty else {
            currentVerse = nil
            isFavorite = false
            state = .error("Nenhum versículo disponível.")
            return
        }

        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let index = (dayOfYear - 1) % allVerses.count
        let verse = allVerses[index]

        currentVerse = verse
        isFavorite = favoriteIDs.contains(verse.id)
        state = .loaded(verse)
    }

    func refreshRandom() {
        guard !allVerses.isEmpty else {
            currentVerse = nil
            isFavorite = false
            state = .error("Nenhum versículo disponível.")
            return
        }

        guard allVerses.count > 1 else {
            currentVerse = allVerses.first
            guard let current = currentVerse else { return }
            isFavorite = currentVerse.map { favoriteIDs.contains($0.id) } ?? false
            state = .loaded(current)
            return
        }

        var newVerse: Verse
        repeat {
            newVerse = allVerses.randomElement()!
        } while newVerse.id == currentVerse?.id

        currentVerse = newVerse
        isFavorite = favoriteIDs.contains(newVerse.id)
        guard let current = currentVerse else { return }
        state = .loaded(current)
    }

    func toggleFavorite() {
        guard let verse = currentVerse else { return }

        if favoriteIDs.contains(verse.id) {
            favoriteIDs.remove(verse.id)
            isFavorite = false
        } else {
            favoriteIDs.insert(verse.id)
            isFavorite = true
            requestReviewIfAppropriate()
        }

        favoritesStore.saveFavoriteIDs(favoriteIDs)
    }

    func favoritesList() -> [Verse] {
        let ids = favoriteIDs
        return allVerses.filter { ids.contains($0.id) }
            .sorted { $0.book < $1.book }
    }

    func removeFavorite(_ verse: Verse) {
        favoriteIDs.remove(verse.id)
        favoritesStore.saveFavoriteIDs(favoriteIDs)

        if currentVerse?.id == verse.id {
            isFavorite = false
        }
    }

    private func requestReviewIfAppropriate() {
        let count = favoriteIDs.count

        if count == 1 || count == 7 || count == 20 {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
    }
}
