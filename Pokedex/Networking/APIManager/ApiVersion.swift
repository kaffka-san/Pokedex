//
//  ApiVersion.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 05.01.2025.
//

import Foundation

enum ApiVersion: String, Codable {
    case version1 = "v1"
    case version2 = "v2"

    static var defaultVersion: ApiVersion {
        .version2
    }
}
