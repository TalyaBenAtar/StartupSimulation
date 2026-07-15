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

    let bankruptcyLimit: Double = -100_000
    let unicornTarget: Double = 1_000_000_000

    init(company: Company = .empty) {
        self.company = company
    }

    func startNewGame(
        companyName: String,
        industry: Industry
    ) {
        let cleanedName = companyName
            .trimmingCharacters(in: .whitespacesAndNewlines)

        company = Company.newCompany(
            name: cleanedName,
            industry: industry
        )
        
        gameOutcome = .active
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

        company.employeeMorale = clampedPercentage(
            company.employeeMorale +
            candidate.moraleImpact
        )

        return true
    }

    func fire(_ employee: Employee) -> Bool {
        company.cash -= employee.severanceCost

        company.employees.removeAll {
            $0.id == employee.id
        }

        company.employeeMorale = clampedPercentage(
            company.employeeMorale - 5
        )

        return true
    }

    func canAfford(_ candidate: Employee) -> Bool {
        let requiredCash =
            candidate.hiringCost +
            candidate.monthlySalary

        return company.cash >= requiredCash
    }


    func advanceMonth() -> MonthResult {
        let completedMonth = company.month

        let previousCash = company.cash
        let previousRevenue = company.monthlyRevenue
        let previousMarketValue = company.marketValue
        let previousProductQuality = company.productQuality
        let previousMorale = company.employeeMorale

        let productContribution = company.employees.reduce(0.0) {
            $0 + $1.productContribution
        }

        let revenueContribution = company.employees.reduce(0.0) {
            $0 + $1.revenueContribution
        }

        let marketValueContribution = company.employees.reduce(0.0) {
            $0 + $1.marketValueContribution
        }

        updateProductQuality(
            contribution: productContribution
        )

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
        

        return MonthResult(
            completedMonth: completedMonth,
            previousCash: previousCash,
            newCash: company.cash,
            previousRevenue: previousRevenue,
            newRevenue: company.monthlyRevenue,
            previousMarketValue: previousMarketValue,
            newMarketValue: company.marketValue,
            previousProductQuality: previousProductQuality,
            newProductQuality: company.productQuality,
            previousMorale: previousMorale,
            newMorale: company.employeeMorale,
            totalExpenses: totalExpenses,
            monthlyProfit: monthlyProfit
        )
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

    private func updateProductQuality(
        contribution: Double
    ) {
        let moraleMultiplier =
            Double(company.employeeMorale) / 100.0

        let founderContribution = 0.5

        let employeeGrowth =
            contribution *
            0.35 *
            moraleMultiplier

        let maintenanceLoss: Double

        if company.employees.isEmpty {
            maintenanceLoss = 1.5
        } else {
            maintenanceLoss = 0.5
        }

        let rawChange =
            founderContribution +
            employeeGrowth -
            maintenanceLoss

        let qualityChange = Int(rawChange.rounded())

        company.productQuality = clampedPercentage(
            company.productQuality + qualityChange
        )
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
            company.employeeMorale = 80
            return
        }

        var moraleChange = Int.random(in: -2...2)

        if company.monthlyProfit < 0 {
            moraleChange -= 2
        }

        if company.monthlyRevenue > company.monthlyExpenses * 1.5 {
            moraleChange += 1
        }

        company.employeeMorale = clampedPercentage(
            company.employeeMorale + moraleChange
        )
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

    private func clampedPercentage(_ value: Int) -> Int {
        min(max(value, 0), 100)
    }
}
