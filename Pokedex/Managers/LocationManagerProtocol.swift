//
//  LocationManagerProtocol.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 03.01.2025.
//

import CoreLocation
import Foundation

protocol LocationManagerProtocol {
    var location: CLLocation? { get }
    func requestUserAuthorization() async throws
    func startCurrentLocationUpdates() async throws
    func stopUpdates()
    func getRandomLocationsNearUser(radius: CLLocationDistance) -> [Location]
}
