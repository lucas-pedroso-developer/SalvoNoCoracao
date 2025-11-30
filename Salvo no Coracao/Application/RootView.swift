//
//  RootView.swift
//  Salvo no Coracao
//
//  Created by Lucas Pedroso on 30/11/25.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var verseViewModel: VerseOfTheDayViewModel
    
    init() {
        let repository = LocalJSONVerseRepository()
        let favoritesStore = UserDefaultsFavoritesStore()
        
        _verseViewModel = StateObject(
            wrappedValue: VerseOfTheDayViewModel(
                repository: repository,
                favoritesStore: favoritesStore
            )
        )
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            VerseOfTheDayView(viewModel: verseViewModel)
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .home:
                        VerseOfTheDayView(viewModel: verseViewModel)
                        
                    case .favorites:
                        FavoritesView(
                            viewModel: FavoritesViewModel(
                                verseOfTheDayViewModel: verseViewModel
                            )
                        )
                        
                    case .memorize:
                        if let verse = coordinator.memorizingVerse {
                            MemorizeView(
                                viewModel: MemorizeViewModel(verse: verse)
                            )
                        } else {
                            Text("Nenhum versículo selecionado.")
                                .foregroundColor(.red)
                        }
                        
                    case .credits:
                        CreditsView()
                    }
                }
        }
    }
}
