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

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Picker("Modo de visualização", selection: $viewModel.mode) {
                    Text("Ver").tag(MemorizeMode.view)
                    Text("Ocultar").tag(MemorizeMode.hideWords)
                }
                .pickerStyle(.segmented)
                .tint(.blue)
                .accessibilityLabel("Modo de memorização")

                // Níveis de máscara
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
                        }
                    }
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.top, 16)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Memorizar")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
