//
//  CLLocationCoordinate2D+Ext.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 03.01.2025.
//

import MapKit

extension CLLocationCoordinate2D {
    /// Generates a random geographic location within a specified radius (in meters) of the current coordinate.
    ///
    /// - Parameter radius: The radius in meters within which to generate the random location.
    /// - Returns: A `CLLocationCoordinate2D` representing the new random location.
    ///
    /// - Discussion:
    ///   This method calculates a new random location by applying a random bearing and distance
    ///   from the current coordinate, accounting for the Earth's curvature.

    /// - Example:
    ///   ```swift
    ///   let currentLocation = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    ///   let randomLocation = currentLocation.randomLocationWithin(radius: 500)
    ///   print("Random Location: \(randomLocation.latitude), \(randomLocation.longitude)")
    ///   ```
    func randomLocationWithin(radius: CLLocationDistance) -> CLLocationCoordinate2D {
        // Generate a random bearing (direction) in radians.
        let bearing = Double.random(in: 0..<2 * .pi)

        // Generate a random distance from the current location, up to the specified radius.
        let distance = Double.random(in: 0...radius)

        // Convert current latitude and longitude into radians.
        let currentLatitudeRadians = latitude * .pi / 180
        let currentLongitudeRadians = longitude * .pi / 180

        // Calculate the new latitude and longitude based on the random bearing and distance.
        let newLatitudeRadians = asin(
            sin(currentLatitudeRadians) * cos(distance / 6_371_000) +
                cos(currentLatitudeRadians) * sin(distance / 6_371_000) * cos(bearing)
        )
        let newLongitudeRadians = currentLongitudeRadians + atan2(
            sin(bearing) * sin(distance / 6_371_000) * cos(currentLatitudeRadians),
            cos(distance / 6_371_000) - sin(currentLatitudeRadians) * sin(newLatitudeRadians)
        )

        // Convert the new latitude and longitude from radians to degrees.
        let newLatitude = newLatitudeRadians * 180 / .pi
        let newLongitude = newLongitudeRadians * 180 / .pi

        // Return the new coordinates.
        return CLLocationCoordinate2D(latitude: newLatitude, longitude: newLongitude)
    }
}
