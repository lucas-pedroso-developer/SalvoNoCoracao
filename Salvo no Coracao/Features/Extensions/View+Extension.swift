//
//  View+Extension.swift
//  Salvo no Coracao
//
//  Created by Lucas Pedroso on 07/12/25.
//

import SwiftUI

extension View {
    func verseListCardStyle() -> some View {
        self
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                Color(uiColor: .secondarySystemBackground)
            )
            .cornerRadius(14)
            .shadow(
                color: Color.black.opacity(0.04),
                radius: 4,
                x: 0,
                y: 2
            )
    }
}
