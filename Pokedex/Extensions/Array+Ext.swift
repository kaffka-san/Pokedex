//
//  Array+Ext.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 04.01.2025.
//

import Foundation

extension Array where Element == String {
    func findLastOccurrence(of name: String, defaultString: String = "") -> String {
        let uppercasedName = name.uppercased()
        let filteredArray = filter { $0.contains(uppercasedName) }
        return filteredArray.last?.replacingOccurrences(of: "\n", with: "") ?? defaultString
    }
}
