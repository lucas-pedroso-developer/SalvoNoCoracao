//
//  MemorizedVersesStore.swift
//  Salvo no Coracao
//
//  Created by Lucas Pedroso on 03/12/25.
//

protocol MemorizedVersesStore {
    func isMemorized(id: String) -> Bool
    func setMemorized(_ memorized: Bool, for id: String)
    func allMemorizedIds() -> [String]
    func unmarkMemorized(id: String)
    func memorizedIDs() -> Set<String>
    func clearAll()
}
