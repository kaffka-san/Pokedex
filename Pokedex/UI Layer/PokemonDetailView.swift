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
            GeometryReader { geometry in
                ZStack {
                    Color(red: 0.28, green: 0.82, blue: 0.69)
                        .edgesIgnoringSafeArea(.all)
                }
                ScrollView {
                    VStack {
                        // Gap at the top
                        Color.clear.frame(height: geometry.size.height * 0.25)
                        // Card-like view
                        VStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .frame(width: geometry.size.width, height: geometry.size.height * 0.75)
                                    .shadow(radius: 10)
                                Image("bulbasaur")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width * 0.6)
                                    .offset(y: -325)
                            }
                        }
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
