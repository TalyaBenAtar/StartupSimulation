//
//  GameEvent.swift
//  StartUpSimulation
//
//  Created by Talya Benatar on 19/07/2026.
//

import Foundation

struct GameEvent: Identifiable {
    let id = UUID()

    let title: String

    // Explains what happened and why it matters
    let description: String

    // Which startup stages can receive this event
    let allowedStages: [CompanyStage]

    let choices: [EventChoice]
}

struct EventChoice: Identifiable {
    let id = UUID()

    // Button title
    let title: String

    // Explains the strategy and risk before choosing
    let description: String

    // Short visible consequence summary
    let consequencePreview: String

    let cashChange: Double
    let revenueChange: Double
    let moraleChange: Int
    let productChange: Int
    let brandChange: Int
    let marketValueChange: Double
}
