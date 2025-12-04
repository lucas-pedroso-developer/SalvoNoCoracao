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
    case firstLetters
}

@MainActor
final class MemorizeViewModel: ObservableObject {
    let verse: Verse

    @Published var mode: MemorizeMode = .view
    @Published var maskLevel: MaskLevel = .zero
    @Published var isMemorized: Bool

    private let memorizedStore: MemorizedVersesStore
    private static let memorizedKey = "memorizedVerseIds"

    init(verse: Verse, memorizedStore: MemorizedVersesStore) {
        self.verse = verse
//        self.isMemorized = Self.loadIsMemorized(for: verse.id)
        self.memorizedStore = memorizedStore
        self.isMemorized = memorizedStore.isMemorized(id: verse.id)
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

    var firstLettersText: String {
        Self.firstLetters(from: verse.text)
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
    
    static func firstLetters(from text: String) -> String {
        text
            .split(separator: " ")
            .map { word -> String in
                let s = String(word)
                guard let first = s.first else { return "" }
                let restCount = max(s.count - 1, 0)
                let underscores = String(repeating: "_", count: restCount)
                return String(first) + underscores
            }
            .joined(separator: " ")
    }

    func toggleMemorized() {
        isMemorized.toggle()
//        Self.save(isMemorized: isMemorized, for: verse.id)
        memorizedStore.setMemorized(isMemorized, for: verse.id)
    }
    
    private static func loadIsMemorized(for id: String) -> Bool {
        let ids = Set(UserDefaults.standard.stringArray(forKey: memorizedKey) ?? [])
        return ids.contains(id)
    }
    
    private static func save(isMemorized: Bool, for id: String) {
        var ids = Set(UserDefaults.standard.stringArray(forKey: memorizedKey) ?? [])
        if isMemorized {
            ids.insert(id)
        } else {
            ids.remove(id)
        }
        UserDefaults.standard.set(Array(ids), forKey: memorizedKey)
    }
}
