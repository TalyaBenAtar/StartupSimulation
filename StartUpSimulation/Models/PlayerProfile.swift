//
//  PlayerProfile.swift
//  StartUpSimulation
//
//  Created by Talya Benatar on 17/07/2026.
//

import Foundation

struct PlayerProfile {
    var name: String
    var founderWealth: Double

    static let empty = PlayerProfile(
        name: "",
        founderWealth: 0
    )
}
