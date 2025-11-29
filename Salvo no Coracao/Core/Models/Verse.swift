//
//  Verse.swift
//  Salvo no Coracao
//
//  Created by Lucas Pedroso on 26/11/25.
//

import Foundation

struct Verse: Identifiable, Codable, Equatable {
    let id: String
    let book: String
    let chapter: Int
    let verse: Int
    let text: String

    var reference: String {
        "\(book) \(chapter):\(verse)"
    }
}
