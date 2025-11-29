//
//  FavoritesStore.swift
//  Salvo no Coracao
//
//  Created by Lucas Pedroso on 26/11/25.
//

protocol FavoritesStore {
    func loadFavoriteIDs() -> Set<String>
    func saveFavoriteIDs(_ ids: Set<String>)
}
