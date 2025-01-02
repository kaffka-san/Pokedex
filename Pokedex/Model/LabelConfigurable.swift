//
//  LabelConfigurable.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 02.01.2025.
//

import Foundation

protocol LabelConfigurable {
    var text: String { get }
    var description: String { get }
}

struct LabelConfiguration: LabelConfigurable {
    let text: String
    let description: String
}
