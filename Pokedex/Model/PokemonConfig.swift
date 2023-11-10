//
//  PokemonConfig.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 06.11.2023.
//

import Foundation

struct PokemonDetailConfig {
    let id: Int
    let url: String
    let name: String
    let types: [String]
    let imgUrl: String
    let weight: String
    let height: String
    let baseExperience: String

    init(name: String, url: String) {
        id = 0
        self.url = url
        self.name = name
        types = []
        imgUrl = ""
        weight = ""
        height = ""
        baseExperience = ""
    }

    init(
        id: Int,
        url: String,
        name: String,
        types: [String],
        imgUrl: String,
        weight: String,
        height: String,
        baseExperience: String
    ) {
        self.id = id
        self.url = url
        self.name = name
        self.types = types
        self.imgUrl = imgUrl
        self.weight = weight
        self.height = height
        self.baseExperience = baseExperience
    }
}

struct PokemonSpeciesConfig {
    let description: String
    let eggGroups: [String]
    let gender: Gender
    let hatchCounter: String
}

struct Gender {
    let male: String
    let female: String
    let genderless = "Genderless"
    let genderCase: GenderCase
}

enum GenderCase {
    case genderless
    case male
    case female
    case maleFemale
}
