//
//  UserDefaultsFavoritesStore.swift
//  Salvo no Coracao
//
//  Created by Lucas Pedroso on 26/11/25.
//

import Foundation

final class UserDefaultsFavoritesStore: FavoritesStore {
    private let key = "favoriteVerseIDs"

    func loadFavoriteIDs() -> Set<String> {
        let ids = UserDefaults.standard.stringArray(forKey: key) ?? []
        return Set(ids)
    }

    func saveFavoriteIDs(_ ids: Set<String>) {
        UserDefaults.standard.set(Array(ids), forKey: key)
    }
}
