//
//  FavoritesFilter.swift
//  Salvo no Coracao
//
//  Created by Lucas Pedroso on 03/12/25.
//

enum FavoritesFilter: String, CaseIterable, Identifiable {
    case all
    case memorized
    case notMemorized

    var id: String { rawValue }

    var title: String {
        switch self {
        case .all: "Todos"
        case .memorized: "Memorizados"
        case .notMemorized: "Não memorizados"
        }
    }
}
