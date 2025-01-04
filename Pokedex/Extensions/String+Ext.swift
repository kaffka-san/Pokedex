//
//  String+Ext.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 04.01.2025.
//

import Foundation

extension String {
    func removingNewLines() -> String {
        replacingOccurrences(of: "\n", with: "")
    }
}
