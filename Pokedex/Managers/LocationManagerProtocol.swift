//
//  LocationManagerProtocol.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 03.01.2025.
//

import Foundation
import MapKit

protocol LocationManagerProtocol {
    var location: CLLocation? { get }
    func requestUserAuthorization() async throws
    func startCurrentLocationUpdates() async throws
    func stopUpdates()
}
