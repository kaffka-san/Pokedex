//
//  LocationManager.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 03.01.2025.
//

import CoreLocation
import Foundation

@Observable
final class LocationManager: LocationManagerProtocol {
    private let locationManager = CLLocationManager()
    private var locationTask: Task<Void, Error>?

    var location: CLLocation? {
        didSet {
            if location != nil {
                stopUpdates()
            }
        }
    }

    func requestUserAuthorization() async throws {
        locationManager.requestWhenInUseAuthorization()
    }

    func startCurrentLocationUpdates() async throws {
        locationTask?.cancel()

        locationTask = Task {
            for try await locationUpdate in CLLocationUpdate.liveUpdates() {
                await MainActor.run {
                    self.location = locationUpdate.location
                }
            }
        }
    }

    func stopUpdates() {
        locationTask?.cancel()
        locationTask = nil
    }
}
