//
//  Colors.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 05.11.2023.
//

import SwiftUI

enum PokedexColors {
    static let dark = Color(red: 0.19, green: 0.22, blue: 0.26)
    static let lightGray = Color(red: 0.19, green: 0.22, blue: 0.26).opacity(0.4)
    static let male = Color(red: 0.42, green: 0.47, blue: 0.86)
    static let female = Color(red: 0.94, green: 0.45, blue: 0.63)
}

enum ColorType: String {
    case bug = "Bug"
    case dark = "Dark"
    case basic = "Default"
    case dragon = "Dragon"
    case electric = "Electric"
    case fairy = "Fairy"
    case fighting = "Fighting"
    case fire = "Fire"
    case flying = "Flying"
    case ghost = "Ghost"
    case grass = "Grass"
    case ground = "Ground"
    case ice = "Ice"
    case normal = "Normal"
    case poison = "Poison"
    case psychic = "Psychic"
    case rock = "Rock"
    case steel = "Steel"
    case water = "Water"
}
