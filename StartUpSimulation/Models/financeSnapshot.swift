//
//  FinanceSnapshot.swift
//  StartUpSimulation
//
//  Created by Talya Benatar on 18/07/2026.
//

import Foundation

struct FinanceSnapshot {

    // MARK: - Current Position

    let currentCash: Double
    let currentRevenue: Double
    let bankruptcyLimit: Double

    // MARK: - Recurring Expenses

    let operatingExpenses: Double
    let salaryExpenses: Double
    let marketingSubscriptionExpenses: Double
    let totalRecurringExpenses: Double

    // MARK: - Spending During Current Month

    let productSpending: Double
    let oneTimeMarketingSpending: Double
    let hiringSpending: Double
    let severanceSpending: Double
    let totalOneTimeSpending: Double

    // MARK: - Revenue Forecast

    let employeeRevenueGrowth: Double
    let productQualityEffect: Double
    let brandAwarenessEffect: Double
    let moraleEffect: Double
    let missingTeamPenalty: Double

    let projectedNextRevenue: Double
    let projectedMonthlyProfit: Double

    // MARK: - Runway

    let estimatedRunwayMonths: Double?

    init(
        company: Company,
        bankruptcyLimit: Double
    ) {
        currentCash = company.cash
        currentRevenue = company.monthlyRevenue
        self.bankruptcyLimit = bankruptcyLimit

        operatingExpenses =
            company.baseMonthlyExpenses

        salaryExpenses =
            company.salaryExpenses

        marketingSubscriptionExpenses =
            company.marketingSubscriptionExpenses

        totalRecurringExpenses =
            operatingExpenses +
            salaryExpenses +
            marketingSubscriptionExpenses

        productSpending =
            company.monthlyProductSpend

        oneTimeMarketingSpending =
            company.monthlyMarketingSpend

        hiringSpending =
            company.monthlyHiringSpend

        severanceSpending =
            company.monthlySeveranceSpend

        totalOneTimeSpending =
            productSpending +
            oneTimeMarketingSpending +
            hiringSpending +
            severanceSpending

        let totalEmployeeRevenueContribution =
            company.employees.reduce(0.0) {
                total,
                employee in

                total +
                    employee.revenueContribution
            }

        let qualityMultiplier =
            Double(company.productQuality) /
            100.0

        employeeRevenueGrowth =
            totalEmployeeRevenueContribution *
            1_800 *
            qualityMultiplier

        productQualityEffect =
            company.monthlyRevenue *
            (
                Double(
                    company.productQuality - 50
                ) /
                500.0
            )

        brandAwarenessEffect =
            company.monthlyRevenue *
            (
                Double(
                    company.brandAwareness - 50
                ) /
                600.0
            )

        if company.employees.isEmpty {
            moraleEffect = 0

            missingTeamPenalty =
                company.monthlyRevenue * 0.08
        } else {
            moraleEffect =
                company.monthlyRevenue *
                (
                    Double(
                        company.employeeMorale - 50
                    ) /
                    1_000.0
                )

            missingTeamPenalty = 0
        }

        projectedNextRevenue = max(
            0,
            company.monthlyRevenue +
                employeeRevenueGrowth +
                productQualityEffect +
                brandAwarenessEffect +
                moraleEffect -
                missingTeamPenalty
        )

        projectedMonthlyProfit =
            projectedNextRevenue -
            totalRecurringExpenses

        if projectedMonthlyProfit >= 0 {
            estimatedRunwayMonths = nil
        } else {
            let availableCashBeforeBankruptcy =
                max(
                    0,
                    company.cash -
                        bankruptcyLimit
                )

            estimatedRunwayMonths =
                availableCashBeforeBankruptcy /
                abs(projectedMonthlyProfit)
        }
    }

    var currentMonthlyProfit: Double {
        currentRevenue -
            totalRecurringExpenses
    }

    var isProjectedProfitable: Bool {
        projectedMonthlyProfit >= 0
    }

    var financialStatus: FinancialStatus {
        if projectedMonthlyProfit >= 0 {
            return .profitable
        }

        guard let estimatedRunwayMonths else {
            return .profitable
        }

        if estimatedRunwayMonths <= 3 {
            return .critical
        }

        if estimatedRunwayMonths <= 8 {
            return .risky
        }

        return .stable
    }
}

enum FinancialStatus {

    case profitable
    case stable
    case risky
    case critical

    var title: String {
        switch self {
        case .profitable:
            return "Profitable"

        case .stable:
            return "Stable Runway"

        case .risky:
            return "Financial Risk"

        case .critical:
            return "Critical Runway"
        }
    }

    var explanation: String {
        switch self {
        case .profitable:
            return """
            Projected revenue covers the company’s recurring monthly expenses.
            """

        case .stable:
            return """
            The company is currently losing money, but it still has enough runway to adjust its strategy.
            """

        case .risky:
            return """
            The company’s cash is shrinking quickly. Revenue must improve or expenses should be reduced.
            """

        case .critical:
            return """
            Bankruptcy is close. Immediate changes are needed to revenue, salaries, marketing, or operating costs.
            """
        }
    }
}
