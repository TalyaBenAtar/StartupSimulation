//
//  Company.swift
//  StartUpSimulation
//
//  Created by Talya Benatar on 15/07/2026.
//

import Foundation

struct Company {
    var name: String
    var industry: Industry

    var cash: Double
    var marketValue: Double

    var monthlyRevenue: Double
    var baseMonthlyExpenses: Double

    var employeeMorale: Int

    var productQuality: Int
    var majorVersion: Int
    var minorVersion: Int
    var patchVersion: Int

    var brandAwareness: Int
    var activeMonthlyMarketingCampaign: MarketingCampaign?

    var monthlyProductQualityChange: Int
    var monthlyMoraleChange: Int
    var monthlyBrandAwarenessChange: Int
    var monthlyMarketingSpend: Double

    var lastMarketingCampaign: MarketingCampaign?
    var lastMarketingGain: Int
    var lastMarketingWasSubscription: Bool

    var month: Int
    var employees: [Employee]
    var marketValueHistory: [MarketValuePoint]

    var employeeCount: Int {
        employees.count
    }

    var salaryExpenses: Double {
        employees.reduce(0) { total, employee in
            total + employee.monthlySalary
        }
    }

    var marketingSubscriptionExpenses: Double {
        activeMonthlyMarketingCampaign?.monthlyCost ?? 0
    }

    var monthlyExpenses: Double {
        baseMonthlyExpenses +
        salaryExpenses +
        marketingSubscriptionExpenses
    }

    var monthlyProfit: Double {
        monthlyRevenue - monthlyExpenses
    }

    var stage: CompanyStage {
        CompanyStage.stage(for: marketValue)
    }

    static func newCompany(
        name: String,
        industry: Industry
    ) -> Company {
        Company(
            name: name,
            industry: industry,
            cash: 150_000,
            marketValue: 200_000,
            monthlyRevenue: 5_000,
            baseMonthlyExpenses: 8_000,
            employeeMorale: 80,
            productQuality: 20,
            majorVersion: 1,
            minorVersion: 0,
            patchVersion: 0,
            brandAwareness: 10,
            activeMonthlyMarketingCampaign: nil,
            monthlyProductQualityChange: 0,
            monthlyMoraleChange: 0,
            monthlyBrandAwarenessChange: 0,
            monthlyMarketingSpend: 0,
            lastMarketingCampaign: nil,
            lastMarketingGain: 0,
            lastMarketingWasSubscription: false,
            month: 1,
            employees: [],
            marketValueHistory: [
                MarketValuePoint(
                    month: 1,
                    value: 200_000
                )
            ]
        )
    }

    static var empty: Company {
        Company(
            name: "",
            industry: .artificialIntelligence,
            cash: 0,
            marketValue: 0,
            monthlyRevenue: 0,
            baseMonthlyExpenses: 0,
            employeeMorale: 0,
            productQuality: 0,
            majorVersion: 0,
            minorVersion: 0,
            patchVersion: 0,
            brandAwareness: 0,
            activeMonthlyMarketingCampaign: nil,
            monthlyProductQualityChange: 0,
            monthlyMoraleChange: 0,
            monthlyBrandAwarenessChange: 0,
            monthlyMarketingSpend: 0,
            lastMarketingCampaign: nil,
            lastMarketingGain: 0,
            lastMarketingWasSubscription: false,
            month: 0,
            employees: [],
            marketValueHistory: []
        )
    }
}
