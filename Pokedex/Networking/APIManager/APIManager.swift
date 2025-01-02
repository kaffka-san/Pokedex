//
//  APIManager.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 27.12.2024.
//

import Combine
import Foundation

protocol APIManager {
    func request<T: Decodable>(request: APIConvertible) async throws -> T
}
