//
//  LocalJSONVerseRepository.swift
//  Salvo no Coracao
//
//  Created by Lucas Pedroso on 26/11/25.
//

import Foundation

final class LocalJSONVerseRepository: VerseRepository {
    private let fileName: String

    init(fileName: String = "verses") {
        self.fileName = fileName
    }

    func loadVerses() throws -> [Verse] {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw NSError(domain: "VerseRepository", code: 1, userInfo: [NSLocalizedDescriptionKey: "verses.json não encontrado"])
        }

        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([Verse].self, from: data)
    }
}
