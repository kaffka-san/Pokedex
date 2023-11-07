//
//  SettingsView.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 06.11.2023.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel: SettingsViewModel

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            background
            settingButtons
                .sheet(isPresented: $viewModel.showAllGeneration) {
                    generationMenu
                }
                .padding(.trailing, 26)
        }
    }
}

private extension SettingsView {
    var background: some View {
        Rectangle()
            .fill(.black)
            .opacity(0.6)
            .ignoresSafeArea()
    }

    var settingButtons: some View {
        VStack(alignment: .trailing) {
            Button {} label: {
                CapsuleButton(
                    labelText: L.Settings.favouritePokemon,
                    icon: AssetsImages.loveFill
                )
            }
            Button {
                viewModel.showAll()
            } label: {
                CapsuleButton(
                    labelText: L.Settings.allType,
                    icon: AssetsImages.pokeballFill
                )
            }
            Button {
                viewModel.showAllGeneration.toggle()
            } label: {
                CapsuleButton(
                    labelText: L.Settings.allGen,
                    icon: AssetsImages.pokeballFill
                )
            }
            Button {
                viewModel.close()
            } label: {
                AssetsImages.close
                    .padding(.top, 10)
            }
        }
    }

    var generationMenu: some View {
        VStack {
            titleLabel
            generationButtons
        }
        .presentationDetents([.height(580)])
    }

    var titleLabel: some View {
        Text(L.Settings.generationTitle)
            .font(PokedexFonts.title2)
            .padding(.top, 18)
            .padding(.bottom, 24)
            .foregroundColor(PokedexColors.dark)
    }

    var generationButtons: some View {
        LazyVGrid(
            columns: [
                GridItem(.adaptive(minimum: 150))
            ]
        ) {
            ForEach(1...8, id: \.self) { index in
                ZStack(alignment: .top) {
                    Image("\(index)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 155)
                    Text("\(L.Settings.generationTitle) \(viewModel.integerToRoman(index))")
                        .font(PokedexFonts.label1)
                        .padding(.top, 16)
                        .foregroundColor(PokedexColors.dark)
                }
                .onTapGesture {
                    viewModel.showAllGeneration.toggle()
                    viewModel.generationSelected(index)
                }
                .shadow(radius: 20)
            }
        }
        .padding(.horizontal, 26)
    }
}

#Preview {
    SettingsView(
        viewModel: SettingsViewModel(
            close: {},
            generationSelected: { _ in },
            showAll: {}
        )
    )
}
