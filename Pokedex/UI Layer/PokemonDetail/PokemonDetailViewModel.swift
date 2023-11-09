//
//  PokemonDetailViewModel.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 05.11.2023.
//

import AVFoundation
import SwiftUI

final class PokemonDetailViewModel: ObservableObject {
    private weak var coordinator: PokemonsCoordinator?
    private let pokemonsAPI: PokemonsAPIProtocol
    let pokemon: PokemonDetailConfig
    var player: AVAudioPlayer?
    var colorBackground: String {
        pokemon.types.first?.capitalized ?? Constants.neutralBackground
    }

    var idFormatted: String {
        String(format: "#%03d", pokemon.id)
    }

    @Published var pokemonSpecies = PokemonSpeciesConfig(
        description: "",
        eggGroups: [],
        gender: Gender(
            male: "",
            female: "",
            genderCase: .genderless
        ),
        hatchCounter: ""
    )
    @Published var alertConfig: AlertConfig?
    @Published var nextImageUrl: String?
    @Published var previousImageUrl: String?
    @Published var scrollPosition: CGPoint = .zero
    @Binding var favouriteIds: Set<Int>
    @Published var isFavourite: Bool

    init(
        coordinator: PokemonsCoordinator?,
        pokemonsAPI: PokemonsAPIProtocol,
        pokemon: PokemonDetailConfig,
        favouriteIds: Binding<Set<Int>>
    ) {
        self.coordinator = coordinator
        self.pokemonsAPI = pokemonsAPI
        self.pokemon = pokemon
        _favouriteIds = favouriteIds
        isFavourite = favouriteIds.wrappedValue.contains(pokemon.id)
        loadPokemonSpecies()
        loadNextPokemon()
        loadPreviousPokemon()
    }

    @objc
    func goBack() {
        coordinator?.goBack()
    }

    @objc
    func toggleFavourite() {
        if isFavourite {
            favouriteIds.remove(pokemon.id)

        } else {
            favouriteIds.insert(pokemon.id)
        }
        isFavourite.toggle()
        if let encodedData = try? JSONEncoder().encode(favouriteIds) {
            UserDefaults.standard.set(encodedData, forKey: Constants.favourite)
        }
    }

    func loadPokemonSpecies() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let pokemonDetail = try await pokemonsAPI.getPokemonSpecies(name: pokemon.name)
                await self.updateSpecies(pokemonDetail: pokemonDetail)
            } catch {
                print("Error from pokemon \(pokemon.id)")
                print(error)
                await MainActor.run {
                    self.showAlert()
                }
            }
        }
    }

    func loadNextPokemon() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let pokemonDetail = try await pokemonsAPI.getPokemonDetail(name: "\(pokemon.id + 1)")
                await self.updateNext(pokemonDetail: pokemonDetail)
            } catch {
                print(error)
                await MainActor.run {
                    self.showAlert()
                }
            }
        }
    }

    func loadPreviousPokemon() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let pokemonDetail = try await pokemonsAPI.getPokemonDetail(name: "\(pokemon.id - 1)")
                await self.updatePrevious(pokemonDetail: pokemonDetail)
            } catch {
                print(error)
                await MainActor.run {
                    self.showAlert()
                }
            }
        }
    }

    @MainActor
    private func updatePrevious(pokemonDetail: PokemonDetail) {
        previousImageUrl = pokemonDetail.sprites.other?.officialArtwork.frontDefault ?? pokemonDetail.sprites.frontDefault
    }

    @MainActor
    private func updateNext(pokemonDetail: PokemonDetail) {
        nextImageUrl = pokemonDetail.sprites.other?.officialArtwork.frontDefault ?? pokemonDetail.sprites.frontDefault
    }

    @MainActor
    private func updateSpecies(pokemonDetail: PokemonSpecies) {
        pokemonSpecies = PokemonSpeciesConfig(
            description: findLastOccurrence(
                of: pokemon.name,
                in: pokemonDetail.flavorTextEntries.map { $0.flavorText }
            ),
            eggGroups: pokemonDetail.eggGroups.map { $0.name },
            gender: getPokemonGenderChance(femaleEighths: pokemonDetail.genderRate),
            hatchCounter: calculateHatchingSteps(initialHatchCounter: pokemonDetail.hatchCounter)
        )
    }

    // The chance of this Pokemon being female, in eighths; or -1 for genderless
    func getPokemonGenderChance(femaleEighths: Int) -> Gender {
        switch femaleEighths {
        case -1:
            return Gender(male: "", female: "", genderCase: .genderless)
        case 0:
            return Gender(male: "100%", female: "", genderCase: .male)
        case 8:
            return Gender(male: "", female: "100%", genderCase: .female)
        default:
            let femalePercentage = (femaleEighths * 100) / 8
            let malePercentage = 100 - femalePercentage
            return Gender(male: "\(malePercentage)%", female: "\(femalePercentage)%", genderCase: .maleFemale)
        }
    }

    func findLastOccurrence(
        of name: String,
        in array: [String]
    ) -> String {
        let uppercasedName = name.uppercased()
        let filteredArray = array.filter { $0.contains(uppercasedName) }
        return removeNewLines(from: filteredArray.last ?? L.PokemonDetail.defaultString)
    }

    func removeNewLines(from string: String) -> String {
        string.replacingOccurrences(of: "\n", with: "")
    }

    // Initial hatch counter: one must walk 255 × (hatch_counter + 1) steps before this Pokemon's egg hatches
    func calculateHatchingSteps(initialHatchCounter: Int?) -> String {
        guard let counter = initialHatchCounter else {
            return L.PokemonDetail.defaultString
        }
        let baseSteps = 255
        return "\(baseSteps * (counter + 1)) \(L.PokemonDetail.steps)"
    }

    func showAlert() {
        alertConfig = AlertConfig(
            title: L.Errors.genericTitle,
            message: L.Errors.genericMessage
        )
    }

    func playSound() {
        if pokemon.name == "pikachu" {
            guard let path = Bundle.main.path(forResource: "pikachu.mp3", ofType: nil) else {
                return
            }
            let url = URL(fileURLWithPath: path)
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.play()
            } catch {}
        }
    }
}
