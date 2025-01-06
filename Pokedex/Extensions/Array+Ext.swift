//
//  Array+Ext.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 04.01.2025.
//

import Foundation

extension Array where Element == String {
    /// Finds the last occurrence of a string that contains the given `name` (case-insensitive)
    /// and returns it, with optional post-processing.
    ///
    /// - Parameters:
    ///   - name: The string to search for in the array.
    ///   - defaultString: A fallback string to return if no match is found. Defaults to an empty string.
    /// - Returns: The last occurrence of a string containing `name`, with newline characters removed, or `defaultString` if no match is found.

    func findLastOccurrence(of name: String, defaultString: String = "") -> String {
        // Convert the name to uppercase for case-insensitive comparison
        let uppercasedName = name.uppercased()

        // Filter the array to include only elements containing the name
        let filteredArray = filter { $0.contains(uppercasedName) }

        // Return the last matching element with newlines removed, or the default string
        return filteredArray.last?.replacingOccurrences(of: "\n", with: "") ?? defaultString
    }
}
