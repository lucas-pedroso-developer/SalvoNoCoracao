//
//  AppRoute.swift
//  Salvo no Coracao
//
//  Created by Lucas Pedroso on 30/11/25.
//

import Foundation

/// Rotas principais do app.
/// `.home` existe por semântica, mas não vai para o `path`:
/// a Home é sempre a tela root.
enum AppRoute: Hashable {
    case home
    case favorites
    case memorize
    case credits
    case themes 
}
