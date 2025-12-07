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
    @Published private(set) var state: VerseOfTheDayState = .idle

    private let repository: VerseRepository
    private let favoritesStore: FavoritesStore

    private var allVerses: [Verse] = []
    private var favoriteIDs: Set<String> = []

    var totalVersesCount: Int {
        allVerses.count
    }

    var totalFavoritesCount: Int {
        favoriteIDs.count
    }

    init(repository: VerseRepository, favoritesStore: FavoritesStore) {
        self.repository = repository
        self.favoritesStore = favoritesStore
    }
    
    private enum StorageKeys {
        static let lastVerseID = "verseOfTheDay.lastVerseID"
        static let lastVerseDate = "verseOfTheDay.lastVerseDate"
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

        if let stored = loadStoredVerseForToday() {
            currentVerse = stored
            isFavorite = favoriteIDs.contains(stored.id)
            state = .loaded(stored)
            return
        }

        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let index = (dayOfYear - 1) % allVerses.count
        let verse = allVerses[index]

        currentVerse = verse
        isFavorite = favoriteIDs.contains(verse.id)

        storeVerseForToday(verse)

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
            isFavorite = favoriteIDs.contains(current.id)
            storeVerseForToday(current)
            state = .loaded(current)
            return
        }

        var newVerse: Verse
        repeat {
            newVerse = allVerses.randomElement()!
        } while newVerse.id == currentVerse?.id

        currentVerse = newVerse
        isFavorite = favoriteIDs.contains(newVerse.id)

        if let current = currentVerse {
            storeVerseForToday(current)
            state = .loaded(current)
            Haptics.lightImpact()
        }
    }


    func toggleFavorite() {
        guard let verse = currentVerse else { return }

        if favoriteIDs.contains(verse.id) {
            favoriteIDs.remove(verse.id)
            isFavorite = false
            Haptics.lightImpact()
        } else {
            favoriteIDs.insert(verse.id)
            isFavorite = true
            Haptics.success()
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
    
    // MARK: - Persistência do versículo do dia

    private func loadStoredVerseForToday() -> Verse? {
        let defaults = UserDefaults.standard

        guard
            let lastID = defaults.string(forKey: StorageKeys.lastVerseID),
            let lastDate = defaults.object(forKey: StorageKeys.lastVerseDate) as? Date
        else {
            return nil
        }

        let calendar = Calendar.current
        // Só considera se for hoje
        guard calendar.isDateInToday(lastDate) else {
            return nil
        }

        // Procura o versículo no array carregado
        return allVerses.first(where: { $0.id == lastID })
    }

    private func storeVerseForToday(_ verse: Verse) {
        let defaults = UserDefaults.standard
        defaults.set(verse.id, forKey: StorageKeys.lastVerseID)
        defaults.set(Date(), forKey: StorageKeys.lastVerseDate)
    }

    func verses(withIDs ids: Set<String>) -> [Verse] {
        allVerses
            .filter { ids.contains($0.id) }
            .sorted { $0.book < $1.book }
    }

    func totalMemorizedCount(using memorizedStore: MemorizedVersesStore) -> Int {
        let ids = memorizedStore.memorizedIDs()
        return allVerses.filter { ids.contains($0.id) }.count
    }
}
