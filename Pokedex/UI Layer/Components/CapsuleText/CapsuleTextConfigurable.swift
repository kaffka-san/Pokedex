//
//  CapsuleTextConfigurable.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 02.01.2025.
//

import SwiftUI

protocol CapsuleTextConfigurable {
    var text: String { get }
    var font: Font { get }
}

struct CapsuleTextConfiguration: CapsuleTextConfigurable {
    let text: String
    let font: Font
}
