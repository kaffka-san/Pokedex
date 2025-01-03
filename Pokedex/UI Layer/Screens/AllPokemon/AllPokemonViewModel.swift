//
//  AllPokemonViewModel.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 03.11.2023.
//

import Combine
import CoreLocation
import Foundation

final class AllPokemonViewModel: NSObject, ObservableObject {
    private let pokemonService: PokemonServiceProtocol! // swiftlint:disable:this implicitly_unwrapped_optional
    var coordinator: AllPokemonFlow?

    @Published var pokemonsDetailed = [PokemonDetail]()
    @Published var alertConfig: AlertConfig?
    @Published var isLoading = false
    @Published var showSettingsMenu = false
    @Published var disablePagination = false
    @Published var favouriteIds = Set<Int>()
    @Published var showingFavourites = false
    @Published var userLocation = MockLocation.location
    @Published private var lastGenerationIndex = 0
    @Published var pokemons = [Pokemon]() {
        didSet {
            _ = pokemons.map { loadPokemon(for: $0) }
        }
    }

    init(pokemonService: PokemonServiceProtocol) {
        self.pokemonService = pokemonService
    }
}

// MARK: - Public methods
extension AllPokemonViewModel {
    func getFavouritePokemonIds() {
        if let decodedData = UserDefaults.standard.data(forKey: Constants.favourite) {
            if let decodedSet = try? JSONDecoder().decode(Set<Int>.self, from: decodedData) {
                favouriteIds = decodedSet
            }
        }
    }

    @MainActor
    func loadPokemons() {
        isLoading = true
        Task { [weak self] in
            guard let self else { return }
            do {
                let pokemonsList = try await pokemonService.getPokemons(offset: 0)
                isLoading = false
                update(pokemonsList: pokemonsList)
            } catch let error as NetworkingError {
                isLoading = false
                showAlert(for: error)
            }
        }
    }

    @MainActor
    func refresh() {
        if showingFavourites {
            getFavourite()
        } else if disablePagination {
            loadGeneration(index: lastGenerationIndex)
        } else {
            loadPokemons()
        }
    }

    func getFavourite() {
        if showingFavourites {
            showingFavourites = true
            getFavouritePokemonIds()
            pokemons = []
            pokemons = favouriteIds.map { id in
                Pokemon(name: "", url: "\(id)")
            }
        }
    }

    @MainActor
    func showAllPokemons() {
        loadPokemons()
        showingFavourites = false
        disablePagination = false
        lastGenerationIndex = 0
    }

    @MainActor
    func loadGeneration(index: Int) {
        isLoading = true
        lastGenerationIndex = index
        disablePagination = true
        Task { [weak self] in
            guard let self else { return }
            do {
                let pokemonsList = try await pokemonService.getPokemonForGeneration(generation: index)
                self.updateGeneration(pokemonsList: pokemonsList)
                isLoading = false
            } catch let error as NetworkingError {
                isLoading = false
                self.showAlert(for: error)
            }
        }
    }

    @MainActor
    func loadNextPage(for pokemon: Pokemon) {
        guard !isLoading, !disablePagination, !showingFavourites else { return }
        let isLastPost = pokemons.last?.id == pokemon.id
        if isLastPost {
            isLoading = true
            Task { [weak self] in
                guard let self else { return }
                do {
                    let pokemons = try await pokemonService.getPokemons(offset: self.pokemons.count)
                    self.isLoading = false
                    self.pokemons.append(contentsOf: pokemons.results)

                } catch let error as NetworkingError {
                    showAlert(for: error)
                    isLoading = false
                }
            }
        }
    }

    func loadPokemon(for pokemon: Pokemon) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let pokemonDetail = try await pokemonService.getPokemonDetail(name: String(pokemon.id))
                await self.update(pokemonDetail: pokemonDetail)
                await MainActor.run {
                    self.isLoading = false
                }
            } catch let error as NetworkingError {
                await MainActor.run {
                    self.showAlert(for: error)
                    self.isLoading = false
                }
            }
        }
    }

    func getColorBackground(for pokemon: PokemonDetail) -> String {
        pokemon.types.first?.type.name.capitalized ?? Constants.neutralBackground
    }

    func goToDetailView(for pokemon: PokemonDetail) {
        let pokemonConfig = PokemonDetailConfig(
            id: pokemon.id,
            url: pokemons.first(where: { $0.id == pokemon.id })?.url ?? "",
            name: pokemon.name,
            types: pokemon.types.map { $0.type.name },
            imgUrl: pokemon.sprites.other?.officialArtwork.frontDefault ?? pokemon.sprites.frontDefault ?? "",
            weight: convertToPoundsAndKilograms(pokemon.weight),
            height: convertToFeetInchesAndCentimeters(pokemon.height),
            baseExperience: describeValue(pokemon.baseExperience)
        )

        coordinator?.showDetail(pokemon: pokemonConfig)
    }
}

// MARK: - Private methods
private extension AllPokemonViewModel {
    @MainActor
    func updateGeneration(pokemonsList: PokemonsGeneration) {
        pokemons = pokemonsList.pokemonSpecies
    }

    @MainActor
    func update(pokemonsList: Pokemons) {
        pokemons = pokemonsList.results
    }

    @MainActor
    func update(pokemonDetail: PokemonDetail) {
        pokemonsDetailed.append(pokemonDetail)
    }

    func describeValue(_ value: Int?) -> String {
        guard let intValue = value else {
            return L.PokemonDetail.defaultString
        }
        return "\(intValue)"
    }

    func showAlert(for error: NetworkingError) {
        alertConfig = AlertConfig(
            title: error.localizedDescription.title,
            message: error.localizedDescription.message
        )
    }

    func convertToPoundsAndKilograms(_ value: Int) -> String {
        let weightInKilograms = Double(value) / 10.0
        let weightInPounds = weightInKilograms * 2.20462 // Convert kg to lbs
        let formattedWeightInKilograms = String(format: "%.1f kg", weightInKilograms)
        let formattedWeightInPounds = String(format: "%.1f lbs", weightInPounds)

        return "\(formattedWeightInPounds) (\(formattedWeightInKilograms))"
    }

    func convertToFeetInchesAndCentimeters(_ decimeters: Int) -> String {
        let centimetersPerDecimeter = 10.0
        let centimetersPerInch = 2.54
        let inchesPerFoot = 12.0
        // Convert decimeters to centimeters
        let centimeters = Double(decimeters) * centimetersPerDecimeter
        // Convert centimeters to inches
        let totalInches = centimeters / centimetersPerInch
        // Calculate feet and the remaining inches
        let feet = Int(totalInches / inchesPerFoot)
        let inches = totalInches.truncatingRemainder(dividingBy: inchesPerFoot)
        // Format the height in feet and inches
        let formattedHeightInFeetAndInches = "\(feet)'\(String(format: "%.1f", inches))\""
        // Format the height in centimeters
        let formattedHeightInCentimeters = String(format: "%.0f cm", centimeters)
        return "\(formattedHeightInFeetAndInches) (\(formattedHeightInCentimeters))"
    }
}
