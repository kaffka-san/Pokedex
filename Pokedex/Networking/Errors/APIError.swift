//
//  APIError.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 03.11.2023.
//

import Foundation

enum APIError: Error {
    case genericError(underlyingError: Error)
    case encodingError(underlyingError: Error)
    case decodingError(underlyingError: Error)
    case apiResponseError(underlyingError: APIResponseError)
    case wrongUrl(underlyingError: Error)
    case timeoutError
    case missingToken
}
