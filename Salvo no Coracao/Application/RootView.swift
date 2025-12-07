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
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var showOnboarding = false

    private let memorizedStore: MemorizedVersesStore
    
    init() {
        let repository = LocalJSONVerseRepository()
        let favoritesStore = UserDefaultsFavoritesStore()
        let memorizedStore = UserDefaultsMemorizedVersesStore()
        
        _verseViewModel = StateObject(
            wrappedValue: VerseOfTheDayViewModel(
                repository: repository,
                favoritesStore: favoritesStore
            )
        )
        self.memorizedStore = memorizedStore
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            VerseOfTheDayView(viewModel: verseViewModel, memorizedStore: memorizedStore)
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .home:
                        VerseOfTheDayView(
                            viewModel: verseViewModel,
                            memorizedStore: memorizedStore
                        )
                        
                    case .favorites:
                        FavoritesView(
                            viewModel: FavoritesViewModel(
                                verseOfTheDayViewModel: verseViewModel,
                                memorizedStore: memorizedStore
                            )
                        )
                        .environmentObject(coordinator)
                        
                    case .memorize:
                        if let verse = coordinator.memorizingVerse {
                            MemorizeView(
                                viewModel: MemorizeViewModel(verse: verse,
                                                             memorizedStore: memorizedStore)
                            )
                            .environmentObject(coordinator)
                        } else {
                            Text("Nenhum versículo selecionado.")
                                .foregroundColor(.red)
                        }
                        
                    case .credits:
                        CreditsView()
                            .environmentObject(coordinator)

                    case .themes:
                           ThemesView()
                               .environmentObject(coordinator)

                    case .memorized:
                        MemorizedListView(
                            viewModel: MemorizedListViewModel(
                                verseOfTheDayViewModel: verseViewModel,
                                memorizedStore: UserDefaultsMemorizedVersesStore()
                            )
                        )
                    }
                }
        }
        .onAppear {
            if !hasSeenOnboarding {
                showOnboarding = true
            }
        }
        .fullScreenCover(isPresented: $showOnboarding) {
            OnboardingView {
                hasSeenOnboarding = true
                showOnboarding = false
            }
        }
    }
}
