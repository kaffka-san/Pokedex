//
//  MapManager.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 06.01.2025.
//

import Foundation
import MapKit
import SwiftUI

@Observable
final class MapManager: MapManagerProtocol {
    var region = MapCameraPosition.region(MKCoordinateRegion())

    func configureInitialRegion(coordinate: CLLocationCoordinate2D?) {
        guard let coordinate = coordinate else { return }
        region = MapCameraPosition.region(MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        ))
    }
}

protocol MapManagerProtocol {
    var region: MapCameraPosition { get set }
    func configureInitialRegion(coordinate: CLLocationCoordinate2D?)
}
