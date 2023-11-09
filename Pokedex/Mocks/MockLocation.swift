//
//  MockLocation.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 09.11.2023.
//

import CoreLocation

enum MockLocation {
    static let location = Location(
        coordinate: CLLocationCoordinate2D(
            latitude: 40.7128,
            longitude: -74.0060
        )
    )
}
