//
//  GameViewModel.swift
//  StartUpSimulation
//
//  Created by Talya Benatar on 15/07/2026.
//

import Foundation
import SwiftUI

final class GameViewModel: ObservableObject {
    @Published var company: Company
    @Published var gameOutcome: GameOutcome = .active
    @Published var playerProfile: PlayerProfile
    @Published var lastStartupSaleValue: Double = 0

    let bankruptcyLimit: Double = -100_000
    let unicornTarget: Double = 1_000_000_000

    init(
        company: Company = .empty,
        playerProfile: PlayerProfile = .empty
    ) {
        self.company = company
        self.playerProfile = playerProfile
    }

    func startNewGame(
        companyName: String,
        industry: Industry
    ) {
        let cleanedName = companyName
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        company = Company.newCompany(
            name: cleanedName,
            industry: industry
        )

        lastStartupSaleValue = 0
        gameOutcome = .active
    }
    
    func sellStartup() {
        let saleValue = company.marketValue

        lastStartupSaleValue = saleValue
        playerProfile.founderWealth += saleValue
        gameOutcome = .sold
    }

    func hire(_ candidate: Employee) -> Bool {
        let requiredCash =
            candidate.hiringCost +
            candidate.monthlySalary

        guard company.cash >= requiredCash else {
            return false
        }

        var hiredEmployee = candidate
        hiredEmployee.hiredMonth = company.month

        company.cash -= candidate.hiringCost
        company.employees.append(hiredEmployee)

        changeMorale(
            by: candidate.moraleImpact
        )

        return true
    }

    func fire(_ employee: Employee) -> Bool {
        company.cash -= employee.severanceCost

        company.employees.removeAll {
            $0.id == employee.id
        }

        changeMorale(by: -5)

        return true
    }

    func canAfford(_ candidate: Employee) -> Bool {
        let requiredCash =
            candidate.hiringCost +
            candidate.monthlySalary

        return company.cash >= requiredCash
    }
    
    
    func fixBugs() {
        let cost = 2_000.0

        company.cash -= cost
        changeProductQuality(by: 2)

        company.patchVersion += 1
    }

    func developFeature() {
        let cost = 8_000.0

        company.cash -= cost
        changeProductQuality(by: 6)

        company.minorVersion += 1
        company.patchVersion = 0
    }

    func majorRelease() {
        let cost = 20_000.0

        company.cash -= cost
        changeProductQuality(by: 15)

        company.majorVersion += 1
        company.minorVersion = 0
        company.patchVersion = 0
    }
    
    func runOneTimeMarketingCampaign(
        _ campaign: MarketingCampaign
    ) {
        company.cash -= campaign.oneTimeCost
        company.monthlyMarketingSpend += campaign.oneTimeCost

        let gain = campaign.generateOneTimeGain()

        changeBrandAwareness(by: gain)

        company.lastMarketingCampaign = campaign
        company.lastMarketingGain = gain
        company.lastMarketingWasSubscription = false
    }

    func startMonthlyMarketingCampaign(
        _ campaign: MarketingCampaign
    ) {
        company.activeMonthlyMarketingCampaign = campaign
    }

    func cancelMonthlyMarketingCampaign() {
        company.activeMonthlyMarketingCampaign = nil
    }

    func isMarketingCampaignActive(
        _ campaign: MarketingCampaign
    ) -> Bool {
        company.activeMonthlyMarketingCampaign == campaign
    }

    func advanceMonth() -> MonthResult {
        let completedMonth = company.month

        let previousCash = company.cash
        let previousRevenue = company.monthlyRevenue
        let previousMarketValue = company.marketValue

        let previousProductQuality =
            company.productQuality -
            company.monthlyProductQualityChange

        let previousMorale =
            company.employeeMorale -
            company.monthlyMoraleChange

        let previousBrandAwareness =
            company.brandAwareness -
            company.monthlyBrandAwarenessChange

        let productContribution = company.employees.reduce(0.0) {
            $0 + $1.productContribution
        }

        let revenueContribution = company.employees.reduce(0.0) {
            $0 + $1.revenueContribution
        }

        let marketValueContribution = company.employees.reduce(0.0) {
            $0 + $1.marketValueContribution
        }

        processMonthlyMarketing()
        updateBrandAwarenessMaintenance()
        updateProductQuality()

        updateRevenue(
            contribution: revenueContribution
        )

        updateMorale()

        updateMarketValue(
            contribution: marketValueContribution
        )

        let totalExpenses = company.monthlyExpenses

        let monthlyProfit =
            company.monthlyRevenue -
            totalExpenses

        company.cash += monthlyProfit
        company.month += 1

        company.marketValueHistory.append(
            MarketValuePoint(
                month: company.month,
                value: company.marketValue
            )
        )

        updateGameOutcome()

        let result = MonthResult(
            completedMonth: completedMonth,
            previousCash: previousCash,
            newCash: company.cash,
            previousRevenue: previousRevenue,
            newRevenue: company.monthlyRevenue,
            previousMarketValue: previousMarketValue,
            newMarketValue: company.marketValue,
            previousProductQuality: previousProductQuality,
            newProductQuality: company.productQuality,
            totalProductQualityChange:
                company.monthlyProductQualityChange,
            previousMorale: previousMorale,
            newMorale: company.employeeMorale,
            totalMoraleChange:
                company.monthlyMoraleChange,
            previousBrandAwareness:
                previousBrandAwareness,
            newBrandAwareness:
                company.brandAwareness,
            totalBrandAwarenessChange:
                company.monthlyBrandAwarenessChange,
            marketingSpend:
                company.monthlyMarketingSpend,
            marketingCampaign:
                company.lastMarketingCampaign,
            marketingCampaignGain:
                company.lastMarketingGain,
            marketingWasSubscription:
                company.lastMarketingWasSubscription,
            totalExpenses: totalExpenses,
            monthlyProfit: monthlyProfit
        )

        company.monthlyProductQualityChange = 0
        company.monthlyMoraleChange = 0
        company.monthlyBrandAwarenessChange = 0
        company.monthlyMarketingSpend = 0

        return result
    }
    
    private func updateGameOutcome() {
        if company.cash <= bankruptcyLimit {
            gameOutcome = .bankrupt
        } else if company.marketValue >= unicornTarget {
            gameOutcome = .unicorn
        } else {
            gameOutcome = .active
        }
    }

    private func updateProductQuality() {
        let maintenanceLoss: Int

        switch company.employeeCount {
        case 0:
            maintenanceLoss = 2

        case 1...3:
            maintenanceLoss = 1

        default:
            maintenanceLoss = 0
        }

        changeProductQuality(
            by: -maintenanceLoss
        )
    }
    
    private func processMonthlyMarketing() {
        guard let campaign =
            company.activeMonthlyMarketingCampaign
        else {
            return
        }

        let gain = campaign.generateMonthlyGain()

        changeBrandAwareness(by: gain)

        company.monthlyMarketingSpend +=
            campaign.monthlyCost

        company.lastMarketingCampaign = campaign
        company.lastMarketingGain = gain
        company.lastMarketingWasSubscription = true
    }

    private func updateBrandAwarenessMaintenance() {
        guard company.activeMonthlyMarketingCampaign == nil else {
            return
        }

        changeBrandAwareness(by: -1)
    }

    private func updateRevenue(
        contribution: Double
    ) {
        let qualityMultiplier =
            Double(company.productQuality) / 100.0

        let employeeGrowth =
            contribution *
            1_800 *
            qualityMultiplier

        let marketDrift =
            Double.random(in: -3_000...3_000)

        let teamPenalty: Double

        if company.employees.isEmpty {
            teamPenalty = company.monthlyRevenue * 0.08
        } else {
            teamPenalty = 0
        }

        let qualityEffect =
            company.monthlyRevenue *
            (
                Double(company.productQuality - 50) /
                500.0
            )

        company.monthlyRevenue = max(
            0,
            company.monthlyRevenue +
            employeeGrowth +
            qualityEffect +
            marketDrift -
            teamPenalty
        )
    }

    private func updateMorale() {
        guard !company.employees.isEmpty else {
            return
        }

        var moraleChange = Int.random(in: -2...2)

        if company.monthlyProfit < 0 {
            moraleChange -= 2
        }

        if company.monthlyRevenue >
            company.monthlyExpenses * 1.5 {
            moraleChange += 1
        }

        changeMorale(by: moraleChange)
    }

    private func updateMarketValue(
        contribution: Double
    ) {
        let monthlyProfit =
            company.monthlyRevenue -
            company.monthlyExpenses

        let revenueValue =
            company.monthlyRevenue * 6

        let qualityValue =
            Double(company.productQuality) * 2_500

        let employeeValue =
            contribution * 12_000

        let profitValue =
            monthlyProfit * 4

        let teamStabilityValue =
            Double(company.employeeCount) * 8_000

        let targetValue = max(
            25_000,
            revenueValue +
            qualityValue +
            employeeValue +
            profitValue +
            teamStabilityValue
        )

        let movementTowardTarget =
            (targetValue - company.marketValue) * 0.20

        let marketNoise =
            Double.random(in: -12_000...12_000)

        company.marketValue = max(
            0,
            company.marketValue +
            movementTowardTarget +
            marketNoise
        )
    }
    
    private func changeProductQuality(by amount: Int) {
        let previousQuality = company.productQuality

        company.productQuality = clampedPercentage(
            company.productQuality + amount
        )

        let actualChange =
            company.productQuality - previousQuality

        company.monthlyProductQualityChange += actualChange
    }

    private func changeMorale(by amount: Int) {
        let previousMorale = company.employeeMorale

        company.employeeMorale = clampedPercentage(
            company.employeeMorale + amount
        )

        let actualChange =
            company.employeeMorale - previousMorale

        company.monthlyMoraleChange += actualChange
    }
    
    private func changeBrandAwareness(by amount: Int) {
        let previousAwareness =
            company.brandAwareness

        company.brandAwareness = clampedPercentage(
            company.brandAwareness + amount
        )

        let actualChange =
            company.brandAwareness -
            previousAwareness

        company.monthlyBrandAwarenessChange +=
            actualChange
    }

    private func clampedPercentage(_ value: Int) -> Int {
        min(max(value, 0), 100)
    }
}
