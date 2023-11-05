//
//  APIRouter.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 03.11.2023.
//

import Foundation

protocol APIRouter: Router {
    var baseURL: String { get }
    var apiVersion: String { get }
}

extension APIRouter {
    var baseURL: String {
        "https:/pokeapi.co/api/v2"
    }

    var apiVersion: String {
        "v2"
    }
}
