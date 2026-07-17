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
    let totalProductQualityChange: Int

    let previousMorale: Int
    let newMorale: Int
    let totalMoraleChange: Int

    let previousBrandAwareness: Int
    let newBrandAwareness: Int
    let totalBrandAwarenessChange: Int

    let marketingSpend: Double
    let marketingCampaign: MarketingCampaign?
    let marketingCampaignGain: Int
    let marketingWasSubscription: Bool

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
        totalProductQualityChange
    }

    var moraleChange: Int {
        totalMoraleChange
    }

    var brandAwarenessChange: Int {
        totalBrandAwarenessChange
    }

    var hadMarketingActivity: Bool {
        marketingSpend > 0
    }
}
