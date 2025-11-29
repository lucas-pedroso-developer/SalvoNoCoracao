//
//  VerseRepository.swift
//  Salvo no Coracao
//
//  Created by Lucas Pedroso on 26/11/25.
//

protocol VerseRepository {
    func loadVerses() throws -> [Verse]
}
