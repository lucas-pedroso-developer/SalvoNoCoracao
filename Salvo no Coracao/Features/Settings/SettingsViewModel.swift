//
//  SettingsViewModel.swift
//  Salvo no Coracao
//
//  Created by Lucas Pedroso on 07/12/25.
//

import SwiftUI
import Combine

@MainActor
final class SettingsViewModel: ObservableObject {
    @AppStorage("verseFontSize")
    private var verseFontSizeRaw: String = VerseFontSize.medium.rawValue

    let memorizedStore: MemorizedVersesStore

    init(memorizedStore: MemorizedVersesStore) {
        self.memorizedStore = memorizedStore
    }

    var selectedFontSize: VerseFontSize {
        get {
            VerseFontSize(rawValue: verseFontSizeRaw) ?? .medium
        }
        set {
            verseFontSizeRaw = newValue.rawValue
            objectWillChange.send()
        }
    }

    func clearAllMemorized() {
        memorizedStore.clearAll()
    }
}
