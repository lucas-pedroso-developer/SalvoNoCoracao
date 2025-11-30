//
//  CreditsView.swift
//  Salvo no Coracao
//
//  Created by Lucas Pedroso on 29/11/25.
//

import SwiftUI

import SwiftUI

struct CreditsView: View {

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Salvo no Coração")
                        .font(.title2.bold())
                        .foregroundColor(.primary)

                    Text("Um app simples para ler, guardar e memorizar versículos da Bíblia.")
                        .font(.body)
                        .foregroundColor(.secondary)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Créditos bíblicos")
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text(
                        "Os textos bíblicos exibidos no app são baseados na Bíblia Livre (BLV), " +
                        "uma tradução em português disponível sob a licença Creative Commons CC BY-SA 4.0."
                    )
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                    Link(
                        "Saiba mais em biblialivre.com.br",
                        destination: URL(string: "https://www.biblialivre.com.br")!
                    )
                    .font(.footnote)
                    .foregroundColor(.blue)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Sobre o app")
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text(
                        "Este app foi criado para ajudar cristãos a terem versículos sempre à mão, " +
                        "refletirem neles ao longo do dia e guardarem a Palavra no coração."
                    )
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }

                Spacer(minLength: 16)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Versão \(appVersion)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(20)
        }
        .navigationTitle("Sobre & Créditos")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        CreditsView()
    }
}
