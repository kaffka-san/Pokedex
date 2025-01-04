//
//  HTTPMethod.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 04.01.2025.
//

import Foundation

enum HTTPMethod: String, Codable {
    case get = "GET"
    case delete = "DELETE"
    case put = "PUT"
    case post = "POST"
}
