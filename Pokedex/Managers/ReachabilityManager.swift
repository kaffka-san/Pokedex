//
//  ReachabilityManager.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 03.01.2025.
//

import Foundation
import Reachability

final class ReachabilityManager: ReachabilityManagerProtocol {
    private var reachability: Reachability? = try? Reachability()

    var hasNoConnection: Bool {
        reachability?.connection == Reachability.Connection.unavailable
    }

    init() {
        try? reachability?.startNotifier()
    }

    deinit {
        reachability?.stopNotifier()
    }
}
