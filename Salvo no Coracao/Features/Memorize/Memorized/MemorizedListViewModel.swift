//
//  MemorizedListViewModel.swift
//  Salvo no Coracao
//
//  Created by Lucas Pedroso on 07/12/25.
//

import SwiftUI
import Combine

@MainActor
final class MemorizedListViewModel: ObservableObject {
    @Published private(set) var memorizedVerses: [Verse] = []

    private let verseOfTheDayViewModel: VerseOfTheDayViewModel
    let memorizedStore: MemorizedVersesStore

    init(
        verseOfTheDayViewModel: VerseOfTheDayViewModel,
        memorizedStore: MemorizedVersesStore
    ) {
        self.verseOfTheDayViewModel = verseOfTheDayViewModel
        self.memorizedStore = memorizedStore
        reload()
    }

    func reload() {
        let ids = memorizedStore.memorizedIDs()
        memorizedVerses = verseOfTheDayViewModel.verses(withIDs: ids)
    }

    func unmemorize(_ verse: Verse) {
        memorizedStore.unmarkMemorized(id: verse.id)
        reload()
    }
}
