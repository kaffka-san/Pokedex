//
//  String+Ext.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 04.01.2025.
//

import Foundation

extension String {
    /// Removes all newline characters (`\n`) from the string.
    ///
    /// - Returns: A new string with all newline characters replaced by an empty string.
    func removingNewLines() -> String {
        replacingOccurrences(of: "\n", with: "")
    }
}
