//
//  FavoritesViewModel.swift
//  Salvo no Coracao
//
//  Created by Lucas Pedroso on 26/11/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class FavoritesViewModel: ObservableObject {
    @Published private(set) var favorites: [Verse] = []
    let memorizedStore: MemorizedVersesStore

    private let verseOfTheDayViewModel: VerseOfTheDayViewModel

    init(verseOfTheDayViewModel: VerseOfTheDayViewModel, memorizedStore: MemorizedVersesStore) {
        self.verseOfTheDayViewModel = verseOfTheDayViewModel
        self.memorizedStore = memorizedStore
        reload()
    }

    func reload() {
        favorites = verseOfTheDayViewModel.favoritesList()
    }
    
    func removeFavorite(_ verse: Verse) {
        favorites.removeAll { $0.id == verse.id }
        verseOfTheDayViewModel.removeFavorite(verse)
    }
}
