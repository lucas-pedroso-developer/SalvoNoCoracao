//
//  ThemesView.swift
//  Salvo no Coracao
//
//  Created by Lucas Pedroso on 06/12/25.
//

import SwiftUI

struct ThemesView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var selectedTheme: VerseTheme?

    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Versículos por tema")
                        .font(.largeTitle.weight(.bold))
                        .padding(.top, 24)

                    ForEach(VerseTheme.allCases) { theme in
                        Button {
                            selectedTheme = theme
                        } label: {
                            themeCard(theme)
                        }
                        .buttonStyle(.plain)
                    }

                    Spacer(minLength: 16)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
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
        .sheet(item: $selectedTheme) { theme in
            NavigationStack {
                ThemeDetailView(theme: theme)
            }
        }
    }

    private func themeCard(_ theme: VerseTheme) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(theme.title)
                .font(.headline)

            Text(theme.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    NavigationStack {
        ThemesView()
            .environmentObject(AppCoordinator())
    }
}
