//
//  MemorizeView.swift
//  Salvo no Coracao
//
//  Created by Lucas Pedroso on 26/11/25.
//

import SwiftUI
import Combine

struct MemorizeView: View {
    @StateObject var viewModel: MemorizeViewModel
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        VStack(spacing: 16) {
            Picker("Modo de visualização", selection: $viewModel.mode) {
                Text("Ver").tag(MemorizeMode.view)
                Text("Ocultar").tag(MemorizeMode.hideWords)
                Text("1ª letras").tag(MemorizeMode.firstLetters)
            }
            .pickerStyle(.segmented)
            .tint(.blue)
            .accessibilityLabel("Modo de memorização")

            if viewModel.mode == .hideWords {
                HStack {
                    ForEach(MaskLevel.allCases) { level in
                        Button(level.title) {
                            viewModel.maskLevel = level
                        }
                        .font(.caption)
                        .padding(6)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(
                                    level == viewModel.maskLevel
                                    ? Color.blue.opacity(0.12)
                                    : .clear
                                )
                        )
                        .accessibilityLabel("Ocultar \(level.title) do texto")
                    }
                }
            }

            Text(viewModel.verse.reference)
                .font(.title2.weight(.bold))
                .multilineTextAlignment(.center)
                .padding(.top, 24)

            ScrollView {
                Group {
                    switch viewModel.mode {
                    case .view:
                        Text(viewModel.fullText)
                    case .hideWords:
                        Text(viewModel.maskedText)
                    case .firstLetters:
                        Text(viewModel.firstLettersText)
                    }
                }
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.top, 16)
            }

            if viewModel.mode != .view {
                Button("Revelar versículo") {
                    viewModel.mode = .view
                    viewModel.maskLevel = .zero
                }
                .font(.footnote)
                .padding(.top, 8)
            }

            Button {
                viewModel.toggleMemorized()
            } label: {
                Text(viewModel.isMemorized ? "Marcar como NÃO memorizado" : "Marcar como memorizado")
                    .font(.subheadline.weight(.semibold))
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(viewModel.isMemorized ? Color.green.opacity(0.12) : Color.blue.opacity(0.12))
                    .foregroundColor(viewModel.isMemorized ? .green : .blue)
                    .cornerRadius(12)
            }
            .padding(.top, 16)

            Spacer()
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
        .padding()
        .navigationTitle("Memorizar")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()

    }
}

#Preview {
    let mockVerse = Verse(
        id: "SALMO_23_1",
        book: "Salmo",
        chapter: 23,
        verse: 1,
        text: "O Senhor é o meu pastor; nada me faltará."
    )

    let memorizedStore = UserDefaultsMemorizedVersesStore()

    NavigationStack {
        MemorizeView(viewModel: MemorizeViewModel(verse: mockVerse, memorizedStore: memorizedStore))
    }
}
