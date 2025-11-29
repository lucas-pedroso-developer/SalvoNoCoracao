//
//  Salvo_no_CoracaoApp.swift
//  Salvo no Coracao
//
//  Created by Lucas Pedroso on 26/11/25.
//

import SwiftUI
import CoreData

@main
struct Salvo_no_CoracaoApp: App {
    private let repository = LocalJSONVerseRepository()
    private let favoritesStore = UserDefaultsFavoritesStore()
    
    init() {
            UISegmentedControl.applyBlueTint()
        }
        
        var body: some Scene {
            WindowGroup {
                let vm = VerseOfTheDayViewModel(
                    repository: repository,
                    favoritesStore: favoritesStore
                )
                VerseOfTheDayView(viewModel: vm)
            }
        }
}
