//
//  MemorizeViewModel.swift
//  Salvo no Coracao
//
//  Created by Lucas Pedroso on 26/11/25.
//

import Foundation
import SwiftUI
import Combine

enum MemorizeMode {
    case view
    case hideWords
}

@MainActor
final class MemorizeViewModel: ObservableObject {
    let verse: Verse

    @Published var mode: MemorizeMode = .view
    @Published var maskLevel: MaskLevel = .zero

    init(verse: Verse) {
        self.verse = verse
    }

    var fullText: String {
        verse.text
    }

    var maskedText: String {
        guard mode == .hideWords, maskLevel != .zero else {
            return verse.text
        }

        return Self.mask(text: verse.text, level: maskLevel)
    }

    static func mask(text: String, level: MaskLevel) -> String {
        let words = text.split(separator: " ")
        guard !words.isEmpty else { return text }

        let total = words.count
        let hideCount = Int(Double(total) * level.hideFraction)
        if hideCount == 0 { return text }

        let indicesToHide: Set<Int> = {
            if hideCount >= total { return Set(0..<total) }

            let step = max(1, total / hideCount)
            var result = Set<Int>()
            var index = 0
            while result.count < hideCount && index < total {
                result.insert(index)
                index += step
            }
            return result
        }()

        let maskedWords: [String] = words.enumerated().map { index, word in
            if indicesToHide.contains(index) {
                return "____"
            } else {
                return String(word)
            }
        }

        return maskedWords.joined(separator: " ")
    }
}
