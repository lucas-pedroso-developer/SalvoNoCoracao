//
//  VerseFontSize.swift
//  Salvo no Coracao
//
//  Created by Lucas Pedroso on 07/12/25.
//

import Foundation

enum VerseFontSize: String, CaseIterable, Identifiable {
    case small
    case medium
    case large

    var id: String { rawValue }

    var title: String {
        switch self {
        case .small: return "Pequeno"
        case .medium: return "Médio"
        case .large: return "Grande"
        }
    }

    var pointSize: CGFloat {
        switch self {
        case .small:  return 18
        case .medium: return 20
        case .large:  return 24
        }
    }
}
