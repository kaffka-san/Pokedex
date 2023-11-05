//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 05.11.2023.
//

import SwiftUI
import UIKit

struct PokemonDetailView: View {
    @StateObject private var viewModel: PokemonDetailViewModel

    init(
        viewModel: PokemonDetailViewModel
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(0..<100) { index in
                        Text("Row \(index)")
                            .frame(height: 50)
                    }
                }
            }
            .navigationTitle(viewModel.name.capitalized)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {} label: {
                        Label("fav", systemImage: "heart")
                    }
                    .tint(.black)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        viewModel.goBack()
                    } label: {
                        Label("back", systemImage: "arrow.backward")
                    }
                    .tint(.black)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(false)
    }
}

private extension PokemonDetailView {}

#Preview {
    PokemonDetailView(
        viewModel: PokemonDetailViewModel(
            coordinator: nil,
            name: "TestName"
        )
    )
}
