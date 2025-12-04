//
//  FavoritesView.swift
//  Salvo no Coracao
//
//  Created by Lucas Pedroso on 26/11/25.
//

import SwiftUI
import Combine

struct FavoritesView: View {
    @ObservedObject var viewModel: FavoritesViewModel
    @State private var selectedVerse: Verse?
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                Text("Favoritos")
                    .font(.largeTitle.weight(.bold))
                    .padding(.top, 24)

                if viewModel.favorites.isEmpty {
                    Spacer().frame(height: 24)

                    VStack(spacing: 12) {
                        Image("empty_state_image")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200)
                            .accessibilityHidden(true)

                        Text("Nenhum versículo favorito ainda")
                            .font(.headline)
                            .foregroundColor(.primary)

                        Text("Toque em “Favoritar” na tela inicial para guardar os versículos que falaram com você.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: 280)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(
                        "Você ainda não tem versículos favoritos. " +
                        "Use o botão Favoritar na tela principal para salvá-los aqui."
                    )

                    Spacer()
                } else {
                    // 🔹 Filtro + contagem
                    Picker("Filtro", selection: $viewModel.filter) {
                        ForEach(FavoritesFilter.allCases) { filter in
                            Text(filter.title).tag(filter)
                        }
                    }
                    .pickerStyle(.segmented)
                    .tint(.blue)

                    Text("\(viewModel.totalMemorizedCount) de \(viewModel.favorites.count) versículos memorizados")
                        .font(.footnote)
                        .foregroundColor(.secondary)

                    // 🔹 Lista filtrada
                    List {
                        ForEach(viewModel.filteredFavorites) { verse in
                            Button {
                                selectedVerse = verse
                            } label: {
                                favoriteCard(verse)
                            }
                            .buttonStyle(.plain)
                            .listRowSeparator(.hidden)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    viewModel.removeFavorite(verse)
                                } label: {
                                    Label("Remover", systemImage: "trash")
                                }
                            }
                            .accessibilityLabel("Versículo \(verse.reference)")
                            .accessibilityHint("Toque para abrir a tela de memorização deste versículo.")
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .padding(.horizontal, 20)
        }
        .sheet(isPresented: Binding(
            get: { selectedVerse != nil },
            set: { isPresented in
                if !isPresented {
                    selectedVerse = nil
                }
            }
        )) {
            if let verse = selectedVerse {
                MemorizeView(
                    viewModel: MemorizeViewModel(
                        verse: verse,
                        memorizedStore: viewModel.memorizedStore
                    )
                )
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    coordinator.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                }
            }
        }
        .navigationBarBackButtonHidden()
    }

    fileprivate func favoriteCard(_ verse: Verse) -> some View {
        let isMemorized = viewModel.memorizedStore.isMemorized(id: verse.id)

        return VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(verse.reference)
                    .font(.headline)
                    .foregroundColor(.blue)

                Spacer()

                if isMemorized {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.caption)
                            .foregroundColor(.green)

                        Text("Memorizado")
                            .font(.caption2.weight(.semibold))
                            .foregroundColor(.green)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.12))
                    .clipShape(Capsule())
                    .transition(.scale.combined(with: .opacity))
                }
            }

            Text(verse.text)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(14)
        .animation(
            .spring(response: 0.3, dampingFraction: 0.8),
            value: isMemorized
        )
    }
}


//struct FavoritesView: View {
//    @ObservedObject var viewModel: FavoritesViewModel
//    @State private var selectedVerse: Verse?
//    @EnvironmentObject var coordinator: AppCoordinator
//
//    var body: some View {
//        ZStack {
//            Color(uiColor: .systemGray6)
//                .ignoresSafeArea()
//
//            VStack(alignment: .leading, spacing: 16) {
//                Text("Favoritos")
//                    .font(.largeTitle.weight(.bold))
//                    .padding(.top, 24)
//
//                if viewModel.favorites.isEmpty {
//                    Spacer().frame(height: 24)
//
//                    VStack(spacing: 12) {
//                        Image("empty_state_image")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 200)
//                            .accessibilityHidden(true)
//
//                        Text("Nenhum versículo favorito ainda")
//                            .font(.headline)
//                            .foregroundColor(.primary)
//
//                        Text("Toque em “Favoritar” na tela inicial para guardar os versículos que falaram com você.")
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
//                            .multilineTextAlignment(.center)
//                            .frame(maxWidth: 280)
//                    }
//                    .frame(maxWidth: .infinity, alignment: .center)
//                    .accessibilityElement(children: .combine)
//                    .accessibilityLabel(
//                        "Você ainda não tem versículos favoritos. " +
//                        "Use o botão Favoritar na tela principal para salvá-los aqui."
//                    )
//
//                    Spacer()
//                } else {
//                    List {
//                        ForEach(viewModel.favorites) { verse in
//                            Button {
//                                selectedVerse = verse
//                            } label: {
//                                favoriteCard(verse)
//                            }
//                            .buttonStyle(.plain)
//                            .listRowSeparator(.hidden)
//                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
//                                Button(role: .destructive) {
//                                    viewModel.removeFavorite(verse)
//                                } label: {
//                                    Label("Remover", systemImage: "trash")
//                                }
//                            }
//                            .accessibilityLabel("Versículo \(verse.reference)")
//                            .accessibilityHint("Toque para abrir a tela de memorização deste versículo.")
//                        }
//                    }
//                    .listStyle(.plain)
//                    .scrollContentBackground(.hidden)
//                }
//            }
//            .padding(.horizontal, 20)
//        }
//        .sheet(isPresented: Binding(
//            get: { selectedVerse != nil },
//            set: { isPresented in
//                if !isPresented {
//                    selectedVerse = nil
//                }
//            }
//        )) {
//            if let verse = selectedVerse {
//                MemorizeView(viewModel: MemorizeViewModel(verse: verse, memorizedStore: viewModel.memorizedStore))
//            }
//        }
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                Button(action: {
//                    coordinator.dismiss()
//                }) {
//                    Image(systemName: "chevron.left")
//                        .font(.system(size: 18, weight: .medium))
//                }
//            }
//        }
//        .navigationBarBackButtonHidden()
//    }
//
//    fileprivate func favoriteCard(_ verse: Verse) -> some View {
//        VStack(alignment: .leading, spacing: 6) {
//            
//            HStack {
//                Text(verse.reference)
//                    .font(.headline)
//                    .foregroundColor(.blue)
//                
//                Spacer()
//                
//                if viewModel.memorizedStore.isMemorized(id: verse.id) {
//                    HStack(spacing: 4) {
//                        Image(systemName: "checkmark.seal.fill")
//                            .font(.caption)
//                            .foregroundColor(.green)
//                        
//                        Text("Memorizado")
//                            .font(.caption2.weight(.semibold))
//                            .foregroundColor(.green)
//                    }
//                    .transition(.opacity)
//                }
//            }
//            
//            Text(verse.text)
//                .font(.subheadline)
//                .foregroundColor(.secondary)
//                .lineLimit(3)
//                .multilineTextAlignment(.leading)
//        }
//        .padding(12)
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .background(Color.white)
//        .cornerRadius(14)
//    }
//}
