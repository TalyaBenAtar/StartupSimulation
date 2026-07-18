//
//  MonthResult.swift
//  StartUpSimulation
//
//  Created by Talya Benatar on 15/07/2026.
//

import Foundation

struct MonthResult {
    let completedMonth: Int

    // MARK: - Cash

    let previousCash: Double
    let newCash: Double

    // MARK: - Revenue

    let previousRevenue: Double
    let newRevenue: Double

    // MARK: - Market Value

    let previousMarketValue: Double
    let newMarketValue: Double

    // MARK: - Product

    let previousProductQuality: Int
    let newProductQuality: Int
    let totalProductQualityChange: Int

    // MARK: - Morale

    let previousMorale: Int
    let newMorale: Int
    let totalMoraleChange: Int

    // MARK: - Brand Awareness

    let previousBrandAwareness: Int
    let newBrandAwareness: Int
    let totalBrandAwarenessChange: Int

    // MARK: - Marketing Activity

    let marketingSpend: Double
    let marketingCampaign: MarketingCampaign?
    let marketingCampaignGain: Int
    let marketingWasSubscription: Bool

    // MARK: - Recurring Expenses

    let operatingExpenses: Double
    let salaryExpenses: Double
    let marketingSubscriptionExpenses: Double
    let totalRecurringExpenses: Double

    // MARK: - One-Time Spending

    let productSpending: Double
    let hiringSpending: Double
    let severanceSpending: Double
    let oneTimeMarketingSpending: Double
    let totalOneTimeSpending: Double

    // MARK: - Result

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

    var totalExpenses: Double {
        totalRecurringExpenses +
            totalOneTimeSpending
    }

    var netFinancialResult: Double {
        monthlyProfit -
            totalOneTimeSpending
    }
}
