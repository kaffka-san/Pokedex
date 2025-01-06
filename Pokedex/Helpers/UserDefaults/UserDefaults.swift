//
//  UserDefaults.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 04.01.2025.
//

import Foundation

enum UserDefaultsValue {
    private static let userDefaults = UserDefaults.standard
    private enum UserDefaultsKey: String {
        case favouriteIds = "FAVOURITE_IDS"
    }
}

extension UserDefaultsValue {
    // Getter and Setter for favouriteIds
    static var favouriteIds: Set<Int> {
        get {
            guard let data = userDefaults.data(forKey: UserDefaultsKey.favouriteIds.rawValue),
                  let decodedSet = try? JSONDecoder().decode(Set<Int>.self, from: data)
            else {
                return []
            }
            return decodedSet
        }
        set {
            if let encodedData = try? JSONEncoder().encode(newValue) {
                userDefaults.set(encodedData, forKey: UserDefaultsKey.favouriteIds.rawValue)
            }
        }
    }
}
