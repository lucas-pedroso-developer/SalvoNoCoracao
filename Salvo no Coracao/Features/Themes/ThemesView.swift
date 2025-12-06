//
//  ThemesView.swift
//  Salvo no Coracao
//
//  Created by Lucas Pedroso on 06/12/25.
//

import SwiftUI

struct ThemesView: View {
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                Text("Versículos por tema")
                    .font(.largeTitle.weight(.bold))
                    .padding(.top, 24)

                List {
                    ForEach(VerseTheme.allCases) { theme in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(theme.title)
                                .font(.headline)

                            Text(theme.description)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(.insetGrouped)
            }
            .padding(.horizontal, 20)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    coordinator.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    NavigationStack {
        ThemesView()
            .environmentObject(AppCoordinator())
    }
}
