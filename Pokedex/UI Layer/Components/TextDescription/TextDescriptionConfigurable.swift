//
//  TextDescriptionConfigurable.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 02.01.2025.
//

import Foundation

protocol TextDescriptionConfigurable {
    var text: String { get }
    var description: String { get }
}

struct TextDescriptionConfiguration: TextDescriptionConfigurable {
    let text: String
    let description: String
}
