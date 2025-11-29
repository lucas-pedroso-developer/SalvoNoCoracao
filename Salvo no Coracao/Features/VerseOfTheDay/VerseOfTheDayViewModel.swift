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

    private let repository: VerseRepository
    private let favoritesStore: FavoritesStore

    private var allVerses: [Verse] = []
    private var favoriteIDs: Set<String> = []

    init(repository: VerseRepository, favoritesStore: FavoritesStore) {
        self.repository = repository
        self.favoritesStore = favoritesStore
    }

    func load() {
        do {
            allVerses = try repository.loadVerses()
            favoriteIDs = favoritesStore.loadFavoriteIDs()
            selectVerseOfTheDay()
        } catch {
            print("Erro ao carregar versículos: \(error)")
        }
    }

    private func selectVerseOfTheDay() {
        guard !allVerses.isEmpty else { return }

        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let index = (dayOfYear - 1) % allVerses.count
        let verse = allVerses[index]

        currentVerse = verse
        isFavorite = favoriteIDs.contains(verse.id)
    }

    func refreshRandom() {
        guard !allVerses.isEmpty else { return }
        guard allVerses.count > 1 else {
            currentVerse = allVerses.first
            return
        }

        var newVerse: Verse
        repeat {
            newVerse = allVerses.randomElement()!
        } while newVerse.id == currentVerse?.id

        currentVerse = newVerse
        isFavorite = favoriteIDs.contains(newVerse.id)
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
