//
//  AppCoordinator.swift
//  Salvo no Coracao
//
//  Created by Lucas Pedroso on 30/11/25.
//

import Foundation
import Combine

final class AppCoordinator: ObservableObject {
    @Published var path: [AppRoute] = []
    @Published var memorizingVerse: Verse?

    func go(to route: AppRoute) {
        switch route {
        case .home:
            popToRoot()
        case .favorites, .memorize, .credits, .themes, .memorized, .settings:
            path.append(route)
        }
    }
    
    func showHome() {
        go(to: .home)
    }
    
    func showFavorites() {
        go(to: .favorites)
    }
    
    func showCredits() {
        go(to: .credits)
    }
    
    func showMemorize(for verse: Verse) {
        memorizingVerse = verse
        go(to: .memorize)
    }
    
    func showMemorized() {
        go(to: .memorized)
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        _ = path.removeLast()
    }
    
    func popToRoot() {
        path.removeAll()
        memorizingVerse = nil
    }

    func dismiss() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
}
