//
//  VerseTheme.swift
//  Salvo no Coracao
//
//  Created by Lucas Pedroso on 06/12/25.
//

import Foundation

enum VerseTheme: String, CaseIterable, Identifiable {
    case ansiedade
    case tristeza
    case medo
    case solidao
    case esperanca
    case gratidao
    case forca

    var id: String { rawValue }

    var title: String {
        switch self {
        case .ansiedade: "Ansiedade"
        case .tristeza: "Tristeza"
        case .medo: "Medo"
        case .solidao: "Solidão"
        case .esperanca: "Esperança"
        case .gratidao: "Gratidão"
        case .forca: "Força"
        }
    }

    var description: String {
        switch self {
        case .ansiedade:
            return "Quando o coração está acelerado e a mente não para."
        case .tristeza:
            return "Para dias de choro, desânimo e peso na alma."
        case .medo:
            return "Quando você precisa de coragem e proteção."
        case .solidao:
            return "Para quando se sente sozinho, mesmo rodeado de gente."
        case .esperanca:
            return "Para lembrar que Deus ainda está conduzindo a história."
        case .gratidao:
            return "Para aquecer o coração com gratidão."
        case .forca:
            return "Para renovar forças em meio à fraqueza."
        }
    }
}
