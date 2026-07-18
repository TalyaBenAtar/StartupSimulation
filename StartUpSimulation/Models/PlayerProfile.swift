//
//  PlayerProfile.swift
//  StartUpSimulation
//
//  Created by Talya Benatar on 17/07/2026.
//

import Foundation

struct PlayerProfile: Codable {
    var name: String
    var founderWealth: Double

    // MARK: - Startup Career Statistics

    var totalStartupsCreated: Int
    var startupsSold: Int
    var startupsBankrupt: Int
    var unicornsCreated: Int

    // MARK: - Employee Statistics

    var totalEmployeesHired: Int
    var totalEmployeesFired: Int

    // MARK: - Financial Statistics

    var totalMoneyInvested: Double
    var totalMoneyEarnedFromSales: Double

    // MARK: - Empty Profile

    static let empty = PlayerProfile(
        name: "",
        founderWealth: 0,
        totalStartupsCreated: 0,
        startupsSold: 0,
        startupsBankrupt: 0,
        unicornsCreated: 0,
        totalEmployeesHired: 0,
        totalEmployeesFired: 0,
        totalMoneyInvested: 0,
        totalMoneyEarnedFromSales: 0
    )
}
