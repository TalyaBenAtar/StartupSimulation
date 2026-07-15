//
//  MarketValuePoint.swift
//  StartUpSimulation
//
//  Created by Talya Benatar on 15/07/2026.
//

import Foundation

struct MarketValuePoint: Identifiable, Codable {
    let id: UUID
    let month: Int
    let value: Double

    init(
        id: UUID = UUID(),
        month: Int,
        value: Double
    ) {
        self.id = id
        self.month = month
        self.value = value
    }
}
