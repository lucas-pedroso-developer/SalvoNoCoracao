//
//  UserDefaultsMemorizedVersesStore.swift
//  Salvo no Coracao
//
//  Created by Lucas Pedroso on 03/12/25.
//

import Foundation

final class UserDefaultsMemorizedVersesStore: MemorizedVersesStore {
    private let key = "memorizedVerseIds"

    private var ids: Set<String> {
        get {
            Set(UserDefaults.standard.stringArray(forKey: key) ?? [])
        }
        set {
            UserDefaults.standard.set(Array(newValue), forKey: key)
        }
    }

    func isMemorized(id: String) -> Bool {
        ids.contains(id)
    }

    func setMemorized(_ memorized: Bool, for id: String) {
        var current = ids
        if memorized {
            current.insert(id)
        } else {
            current.remove(id)
        }
        ids = current
    }

    func allMemorizedIds() -> [String] {
        Array(ids)
    }
}
