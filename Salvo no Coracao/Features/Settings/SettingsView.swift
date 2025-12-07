//
//  SettingsView.swift
//  Salvo no Coracao
//
//  Created by Lucas Pedroso on 07/12/25.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var showClearAlert = false
    
    var body: some View {
        Form {
            Section("Aparência") {
                Picker("Tamanho da fonte do versículo", selection: $viewModel.selectedFontSize) {
                    ForEach(VerseFontSize.allCases) { size in
                        Text(size.title).tag(size)
                    }
                }
            }
            
            Section("Memorização") {
                Button(role: .destructive) {
                    showClearAlert = true
                } label: {
                    Text("Limpar todos os versículos memorizados")
                }
                .alert("Limpar memorizados?",
                       isPresented: $showClearAlert,
                       actions: {
                    Button("Cancelar", role: .cancel) { }
                    Button("Limpar", role: .destructive) {
                        viewModel.clearAllMemorized()
                    }
                }, message: {
                    Text("Isso vai remover a marcação de memorizado de todos os versículos.")
                })
            }
        }
        .navigationTitle("Ajustes")
        .navigationBarTitleDisplayMode(.inline)
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
