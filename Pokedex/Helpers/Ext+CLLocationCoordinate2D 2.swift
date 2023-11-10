//
//  Ext+CLLocationCoordinate2D 2.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 10.11.2023.
//

import CoreLocation

extension CLLocationCoordinate2D {
    /// Generates a random location within a specified radius of the current location.
    func randomLocationWithin(radius: CLLocationDistance) -> CLLocationCoordinate2D {
        // Generate a random bearing (direction) in radians.
        let bearing = Double.random(in: 0..<2 * .pi)

        // Generate a random distance from the current location, up to the specified radius.
        let distance = Double.random(in: 0...radius)

        // Convert current latitude and longitude into radians
        let currentLatitudeRadians = latitude * .pi / 180
        let currentLongitudeRadians = longitude * .pi / 180

        // Calculate the new latitude and longitude based on the random bearing and distance
        let newLatitudeRadians = asin(
            sin(currentLatitudeRadians) * cos(distance / 6_371_000) +
                cos(currentLatitudeRadians) * sin(distance / 6_371_000) * cos(bearing)
        )
        let newLongitudeRadians = currentLongitudeRadians + atan2(
            sin(bearing) * sin(distance / 6_371_000) * cos(currentLatitudeRadians),
            cos(distance / 6_371_000) - sin(currentLatitudeRadians) * sin(newLatitudeRadians)
        )

        // Convert the new latitude and longitude from radians to degrees
        let newLatitude = newLatitudeRadians * 180 / .pi
        let newLongitude = newLongitudeRadians * 180 / .pi

        // Return the new coordinates
        return CLLocationCoordinate2D(latitude: newLatitude, longitude: newLongitude)
    }
}
