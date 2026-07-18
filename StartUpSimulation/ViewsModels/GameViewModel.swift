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
        var hiredEmployee = candidate
        hiredEmployee.hiredMonth = company.month

        company.cash -= candidate.hiringCost
        company.monthlyHiringSpend +=
            candidate.hiringCost

        company.employees.append(
            hiredEmployee
        )

        changeMorale(
            by: candidate.moraleImpact
        )

        return true
    }

    func fire(_ employee: Employee) -> Bool {
        let severanceCost =
            employee.severanceCost

        company.cash -= severanceCost
        company.monthlySeveranceSpend +=
            severanceCost

        company.employees.removeAll {
            $0.id == employee.id
        }

        changeMorale(by: -5)

        return true
    }

    func canAfford(_ candidate: Employee) -> Bool {
        let projectedCash =
            company.cash -
            candidate.hiringCost

        return projectedCash >
            bankruptcyLimit
    }
    
    
    func fixBugs() {
        let cost = 2_000.0

        company.cash -= cost
        company.monthlyProductSpend += cost

        changeProductQuality(by: 2)

        company.patchVersion += 1
    }

    func developFeature() {
        let cost = 8_000.0

        company.cash -= cost
        company.monthlyProductSpend += cost

        changeProductQuality(by: 6)

        company.minorVersion += 1
        company.patchVersion = 0
    }

    func majorRelease() {
        let cost = 20_000.0

        company.cash -= cost
        company.monthlyProductSpend += cost

        changeProductQuality(by: 15)

        company.majorVersion += 1
        company.minorVersion = 0
        company.patchVersion = 0
    }
    
    func runOneTimeMarketingCampaign(
        _ campaign: MarketingCampaign
    ) {
        company.cash -= campaign.oneTimeCost

        company.monthlyMarketingSpend +=
            campaign.oneTimeCost

        let gain =
            campaign.generateOneTimeGain()

        changeBrandAwareness(by: gain)

        company.lastMarketingCampaign =
            campaign

        company.lastMarketingGain =
            gain

        company.lastMarketingWasSubscription =
            false
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
        let completedMonth =
            company.month

        // MARK: - Values Before Monthly Processing

        let previousCash =
            company.cash

        let previousRevenue =
            company.monthlyRevenue

        let previousMarketValue =
            company.marketValue

        let previousProductQuality =
            company.productQuality -
            company.monthlyProductQualityChange

        let previousMorale =
            company.employeeMorale -
            company.monthlyMoraleChange

        let previousBrandAwareness =
            company.brandAwareness -
            company.monthlyBrandAwarenessChange

        // MARK: - Spending Already Made This Month

        let productSpending =
            company.monthlyProductSpend

        let hiringSpending =
            company.monthlyHiringSpend

        let severanceSpending =
            company.monthlySeveranceSpend

        let oneTimeMarketingSpending =
            company.monthlyMarketingSpend

        let totalOneTimeSpending =
            productSpending +
            hiringSpending +
            severanceSpending +
            oneTimeMarketingSpending

        // MARK: - Employee Contributions

        let revenueContribution =
            company.employees.reduce(0.0) {
                total,
                employee in

                total +
                    employee.revenueContribution
            }

        let marketValueContribution =
            company.employees.reduce(0.0) {
                total,
                employee in

                total +
                    employee.marketValueContribution
            }

        // MARK: - Monthly Company Changes

        processMonthlyMarketing()

        updateBrandAwarenessMaintenance()

        updateProductQuality()

        updateRevenue(
            contribution: revenueContribution
        )

        updateMorale()

        updateMarketValue(
            contribution:
                marketValueContribution
        )

        // MARK: - Recurring Expenses

        let operatingExpenses =
            company.baseMonthlyExpenses

        let salaryExpenses =
            company.salaryExpenses

        let marketingSubscriptionExpenses =
            company.marketingSubscriptionExpenses

        let totalRecurringExpenses =
            operatingExpenses +
            salaryExpenses +
            marketingSubscriptionExpenses

        let monthlyProfit =
            company.monthlyRevenue -
            totalRecurringExpenses

        // One-time spending was already removed
        // when the player performed each action.
        company.cash += monthlyProfit

        company.month += 1

        company.marketValueHistory.append(
            MarketValuePoint(
                month: company.month,
                value: company.marketValue
            )
        )

        updateGameOutcome()

        // MARK: - Month Result

        let result = MonthResult(
            completedMonth: completedMonth,

            previousCash: previousCash,
            newCash: company.cash,

            previousRevenue: previousRevenue,
            newRevenue: company.monthlyRevenue,

            previousMarketValue:
                previousMarketValue,
            newMarketValue:
                company.marketValue,

            previousProductQuality:
                previousProductQuality,
            newProductQuality:
                company.productQuality,
            totalProductQualityChange:
                company.monthlyProductQualityChange,

            previousMorale:
                previousMorale,
            newMorale:
                company.employeeMorale,
            totalMoraleChange:
                company.monthlyMoraleChange,

            previousBrandAwareness:
                previousBrandAwareness,
            newBrandAwareness:
                company.brandAwareness,
            totalBrandAwarenessChange:
                company.monthlyBrandAwarenessChange,

            marketingSpend:
                oneTimeMarketingSpending +
                marketingSubscriptionExpenses,
            marketingCampaign:
                company.lastMarketingCampaign,
            marketingCampaignGain:
                company.lastMarketingGain,
            marketingWasSubscription:
                company.lastMarketingWasSubscription,

            operatingExpenses:
                operatingExpenses,
            salaryExpenses:
                salaryExpenses,
            marketingSubscriptionExpenses:
                marketingSubscriptionExpenses,
            totalRecurringExpenses:
                totalRecurringExpenses,

            productSpending:
                productSpending,
            hiringSpending:
                hiringSpending,
            severanceSpending:
                severanceSpending,
            oneTimeMarketingSpending:
                oneTimeMarketingSpending,
            totalOneTimeSpending:
                totalOneTimeSpending,

            monthlyProfit:
                monthlyProfit
        )

        // MARK: - Prepare for Next Month

        company.monthlyProductQualityChange = 0
        company.monthlyMoraleChange = 0
        company.monthlyBrandAwarenessChange = 0

        company.monthlyProductSpend = 0
        company.monthlyMarketingSpend = 0
        company.monthlyHiringSpend = 0
        company.monthlySeveranceSpend = 0

        company.lastMarketingCampaign = nil
        company.lastMarketingGain = 0
        company.lastMarketingWasSubscription = false

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

        let gain =
            campaign.generateMonthlyGain()

        changeBrandAwareness(by: gain)

        company.lastMarketingCampaign =
            campaign

        company.lastMarketingGain =
            gain

        company.lastMarketingWasSubscription =
            true
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
        let currentRevenue =
            company.monthlyRevenue

        let qualityMultiplier =
            Double(company.productQuality) /
            100.0

        let employeeGrowth =
            contribution *
            1_800 *
            qualityMultiplier

        let productQualityEffect =
            currentRevenue *
            (
                Double(
                    company.productQuality - 50
                ) /
                500.0
            )

        let brandAwarenessEffect =
            currentRevenue *
            (
                Double(
                    company.brandAwareness - 50
                ) /
                600.0
            )

        let moraleEffect: Double

        if company.employees.isEmpty {
            moraleEffect = 0
        } else {
            moraleEffect =
                currentRevenue *
                (
                    Double(
                        company.employeeMorale - 50
                    ) /
                    1_000.0
                )
        }

        let missingTeamPenalty: Double

        if company.employees.isEmpty {
            missingTeamPenalty =
                currentRevenue * 0.08
        } else {
            missingTeamPenalty = 0
        }

        let newRevenue =
            currentRevenue +
            employeeGrowth +
            productQualityEffect +
            brandAwarenessEffect +
            moraleEffect -
            missingTeamPenalty

        company.monthlyRevenue = max(
            0,
            newRevenue
        )
    }

    private func updateMorale() {
        guard !company.employees.isEmpty else {
            return
        }

        var moraleChange = 0

        let monthlyProfit =
            company.monthlyRevenue -
            company.monthlyExpenses

        if monthlyProfit < 0 {
            moraleChange -= 2
        }

        if monthlyProfit > 0 {
            moraleChange += 1
        }

        if company.cash < 0 {
            moraleChange -= 1
        }

        if company.productQuality >= 70 {
            moraleChange += 1
        }

        if company.productQuality <= 30 {
            moraleChange -= 1
        }

        if company.employeeCount >= 6 &&
            company.employeeMorale < 50 {
            moraleChange -= 1
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
            company.monthlyRevenue * 8

        let productValue =
            Double(company.productQuality) *
            3_000

        let brandValue =
            Double(company.brandAwareness) *
            2_000

        let employeeValue =
            contribution * 15_000

        let teamValue =
            Double(company.employeeCount) *
            10_000

        let profitValue: Double

        if monthlyProfit >= 0 {
            profitValue =
                monthlyProfit * 6
        } else {
            profitValue =
                monthlyProfit * 10
        }

        let debtPenalty: Double

        if company.cash < 0 {
            debtPenalty =
                abs(company.cash) * 0.35
        } else {
            debtPenalty = 0
        }

        let targetValue = max(
            25_000,
            revenueValue +
                productValue +
                brandValue +
                employeeValue +
                teamValue +
                profitValue -
                debtPenalty
        )

        let movementTowardTarget =
            (
                targetValue -
                    company.marketValue
            ) * 0.20

        company.marketValue = max(
            0,
            company.marketValue +
                movementTowardTarget
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
