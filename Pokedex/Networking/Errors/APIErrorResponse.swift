//
//  APIErrorResponse.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 03.11.2023.
//

import Foundation

struct APIResponseError: Error, Decodable {
    let code: APIErrorCode
    let message: String
}
