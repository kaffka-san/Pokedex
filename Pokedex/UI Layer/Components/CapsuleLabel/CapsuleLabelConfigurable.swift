//
//  CapsuleLabelConfigurable.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 04.01.2025.
//

import Foundation

protocol CapsuleLabelConfigurable {
    var text: String { get }
    var image: ImageName { get }
}

struct CapsuleLabelConfiguration: CapsuleLabelConfigurable {
    let text: String
    let image: ImageName
}
