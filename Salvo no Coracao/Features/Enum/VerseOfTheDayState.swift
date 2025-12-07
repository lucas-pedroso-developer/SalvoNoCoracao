//
//  VerseOfTheDayState.swift
//  Salvo no Coracao
//
//  Created by Lucas Pedroso on 06/12/25.
//

enum VerseOfTheDayState {
    case idle
    case loading
    case loaded(Verse)
    case error(String)
}
