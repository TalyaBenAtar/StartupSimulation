//
//  Company.swift
//  StartUpSimulation
//
//  Created by Talya Benatar on 15/07/2026.
//

import Foundation

struct Company: Codable {
    var name: String
    var industry: Industry

    // MARK: - Main Financial Values

    var cash: Double
    var marketValue: Double
    var monthlyRevenue: Double
    var baseMonthlyExpenses: Double

    // MARK: - Current Month One-Time Spending

    var monthlyProductSpend: Double
    var monthlyMarketingSpend: Double
    var monthlyHiringSpend: Double
    var monthlySeveranceSpend: Double

    // MARK: - Company Stats

    var employeeMorale: Int

    var productQuality: Int
    var majorVersion: Int
    var minorVersion: Int
    var patchVersion: Int

    var brandAwareness: Int
    var activeMonthlyMarketingCampaign: MarketingCampaign?

    // MARK: - Monthly Stat Changes

    var monthlyProductQualityChange: Int
    var monthlyMoraleChange: Int
    var monthlyBrandAwarenessChange: Int

    // MARK: - Current Month Event Impact
    //
    // These are optional so older saved games can still be decoded.

    var lastEventTitle: String?
    var lastEventChoiceTitle: String?

    var monthlyEventCashChange: Double?
    var monthlyEventRevenueChange: Double?
    var monthlyEventMarketValueChange: Double?

    var monthlyEventProductChange: Int?
    var monthlyEventMoraleChange: Int?
    var monthlyEventBrandChange: Int?

    // MARK: - Last Marketing Result

    var lastMarketingCampaign: MarketingCampaign?
    var lastMarketingGain: Int
    var lastMarketingWasSubscription: Bool

    // MARK: - Progress

    var month: Int
    var employees: [Employee]
    var marketValueHistory: [MarketValuePoint]

    // MARK: - Employees

    var employeeCount: Int {
        employees.count
    }

    var salaryExpenses: Double {
        employees.reduce(0) {
            total,
            employee in

            total + employee.monthlySalary
        }
    }

    // MARK: - Marketing

    var marketingSubscriptionExpenses: Double {
        activeMonthlyMarketingCampaign?
            .monthlyCost ?? 0
    }

    // MARK: - Event Values

    var eventCashChangeThisMonth: Double {
        monthlyEventCashChange ?? 0
    }

    var eventRevenueChangeThisMonth: Double {
        monthlyEventRevenueChange ?? 0
    }

    var eventMarketValueChangeThisMonth: Double {
        monthlyEventMarketValueChange ?? 0
    }

    var eventProductChangeThisMonth: Int {
        monthlyEventProductChange ?? 0
    }

    var eventMoraleChangeThisMonth: Int {
        monthlyEventMoraleChange ?? 0
    }

    var eventBrandChangeThisMonth: Int {
        monthlyEventBrandChange ?? 0
    }

    var hadEventThisMonth: Bool {
        lastEventTitle != nil
    }

    // MARK: - Expenses

    var monthlyExpenses: Double {
        baseMonthlyExpenses +
            salaryExpenses +
            marketingSubscriptionExpenses
    }

    var totalOneTimeSpendingThisMonth: Double {
        monthlyProductSpend +
            monthlyMarketingSpend +
            monthlyHiringSpend +
            monthlySeveranceSpend
    }

    var monthlyProfit: Double {
        monthlyRevenue -
            monthlyExpenses
    }

    var cashChangeThisMonth: Double {
        monthlyProfit -
            totalOneTimeSpendingThisMonth +
            eventCashChangeThisMonth
    }

    // MARK: - Stage

    var stage: CompanyStage {
        CompanyStage.stage(
            for: marketValue
        )
    }

    // MARK: - New Company

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
            monthlyProductSpend: 0,
            monthlyMarketingSpend: 0,
            monthlyHiringSpend: 0,
            monthlySeveranceSpend: 0,
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
            lastEventTitle: nil,
            lastEventChoiceTitle: nil,
            monthlyEventCashChange: nil,
            monthlyEventRevenueChange: nil,
            monthlyEventMarketValueChange: nil,
            monthlyEventProductChange: nil,
            monthlyEventMoraleChange: nil,
            monthlyEventBrandChange: nil,
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

    // MARK: - Empty Company

    static var empty: Company {
        Company(
            name: "",
            industry: .artificialIntelligence,
            cash: 0,
            marketValue: 0,
            monthlyRevenue: 0,
            baseMonthlyExpenses: 0,
            monthlyProductSpend: 0,
            monthlyMarketingSpend: 0,
            monthlyHiringSpend: 0,
            monthlySeveranceSpend: 0,
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
            lastEventTitle: nil,
            lastEventChoiceTitle: nil,
            monthlyEventCashChange: nil,
            monthlyEventRevenueChange: nil,
            monthlyEventMarketValueChange: nil,
            monthlyEventProductChange: nil,
            monthlyEventMoraleChange: nil,
            monthlyEventBrandChange: nil,
            lastMarketingCampaign: nil,
            lastMarketingGain: 0,
            lastMarketingWasSubscription: false,
            month: 0,
            employees: [],
            marketValueHistory: []
        )
    }
}
