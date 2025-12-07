//
//  MemorizedListView.swift
//  Salvo no Coracao
//
//  Created by Lucas Pedroso on 07/12/25.
//

import SwiftUI

struct MemorizedListView: View {
    @ObservedObject var viewModel: MemorizedListViewModel
    @State private var selectedVerse: Verse?
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                Text("Versículos memorizados")
                    .font(.largeTitle.weight(.bold))
                    .padding(.top, 24)

                if viewModel.memorizedVerses.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.memorizedVerses) { verse in
                                Button {
                                    selectedVerse = verse
                                } label: {
                                    memorizedCard(verse)
                                }
                                .buttonStyle(.plain)
                                .accessibilityLabel("Versículo \(verse.reference)")
                                .accessibilityHint("Toque para revisar a memorização deste versículo.")
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .onAppear {
            viewModel.reload()
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

    // MARK: - Empty state

    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.seal")
                .font(.system(size: 44, weight: .regular))
                .foregroundColor(.green.opacity(0.7))

            Text("Nenhum versículo memorizado ainda")
                .font(.headline)
                .foregroundColor(.primary)

            Text("Use o botão “Memorizar” na tela inicial ou nos favoritos para começar a guardar a Palavra no coração.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 280)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(
            "Você ainda não tem versículos memorizados. " +
            "Use o botão Memorizar para começar a praticar."
        )
    }

    // MARK: - Card

    private func memorizedCard(_ verse: Verse) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(verse.reference)
                    .font(.headline)
                    .foregroundColor(.blue)

                Spacer()

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
            }

            Text(verse.text)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(3)
                .multilineTextAlignment(.leading)

            HStack {
                Spacer()
                Button {
                    viewModel.unmemorize(verse)
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "xmark.circle")
                        Text("Desmarcar")
                    }
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.red.opacity(0.08))
                    .foregroundColor(.red)
                    .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
            .padding(.top, 4)
        }
        .verseListCardStyle()
    }
}
