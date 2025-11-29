//
//  MaskLevel.swift
//  Salvo no Coracao
//
//  Created by Lucas Pedroso on 26/11/25.
//

import Foundation

enum MaskLevel: Int, CaseIterable, Identifiable {
    case zero = 0
    case low = 20
    case medium = 40
    case high = 60
    case extreme = 80

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .zero: "0%"
        case .low: "20%"
        case .medium: "40%"
        case .high: "60%"
        case .extreme: "80%"
        }
    }

    var hideFraction: Double {
        Double(rawValue) / 100.0
    }
}
