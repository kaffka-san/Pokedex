//
//  APIErrorCode.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 03.11.2023.
//

import Foundation

enum APIErrorCode: String, Decodable {
    case invalidFood = "invalid_food"
    case controversialFood = "controversial_food"
    case recommendationNotReady = "recommendation_is_not_ready"
    case invalidAuthToken = "invalid_auth_token"
    case unknownRefreshToken = "unknown_refresh_token"
    case recommendationCapReached = "recommendation_cap_reached"
}
