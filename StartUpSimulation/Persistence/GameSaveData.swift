//
//  GameSaveData.swift
//  StartUpSimulation
//
//  Created by Talya Benatar on 18/07/2026.
//

import Foundation

struct GameSaveData: Codable {
    var playerProfile: PlayerProfile
    var company: Company
    var gameOutcome: GameOutcome
    var lastStartupSaleValue: Double
}
