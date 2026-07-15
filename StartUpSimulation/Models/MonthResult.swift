//
//  MonthResult.swift
//  StartUpSimulation
//
//  Created by Talya Benatar on 15/07/2026.
//

import Foundation

struct MonthResult {
    let completedMonth: Int

    let previousCash: Double
    let newCash: Double

    let previousRevenue: Double
    let newRevenue: Double

    let previousMarketValue: Double
    let newMarketValue: Double

    let previousProductQuality: Int
    let newProductQuality: Int

    let previousMorale: Int
    let newMorale: Int

    let totalExpenses: Double
    let monthlyProfit: Double

    var cashChange: Double {
        newCash - previousCash
    }

    var revenueChange: Double {
        newRevenue - previousRevenue
    }

    var marketValueChange: Double {
        newMarketValue - previousMarketValue
    }

    var productQualityChange: Int {
        newProductQuality - previousProductQuality
    }

    var moraleChange: Int {
        newMorale - previousMorale
    }
}
