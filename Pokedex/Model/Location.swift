//
//  Location.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 10.11.2023.
//

import CoreLocation

struct Location: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}
