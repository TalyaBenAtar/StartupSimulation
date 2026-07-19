//
//  GameViewModel.swift
//  StartUpSimulation
//
//  Created by Talya Benatar on 15/07/2026.
//

import Foundation
import SwiftUI

final class GameViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published var company: Company
    @Published var gameOutcome: GameOutcome
    @Published var playerProfile: PlayerProfile
    @Published var lastStartupSaleValue: Double
    @Published var currentEvent: GameEvent?

    // MARK: - Game Limits

    let bankruptcyLimit: Double = -100_000
    let unicornTarget: Double = 1_000_000_000

    // MARK: - Startup State

    var hasActiveStartup: Bool {
        !company.name.isEmpty &&
            gameOutcome == .active
    }

    // MARK: - Initialization

    init(
        company: Company = .empty,
        playerProfile: PlayerProfile = .empty
    ) {
        if let savedGame =
            GameSaveManager.shared.load() {

            self.company =
                savedGame.company

            self.playerProfile =
                savedGame.playerProfile

            self.gameOutcome =
                savedGame.gameOutcome

            self.lastStartupSaleValue =
                savedGame.lastStartupSaleValue

        } else {
            self.company = company
            self.playerProfile = playerProfile
            self.gameOutcome = .active
            self.lastStartupSaleValue = 0
        }

        self.currentEvent = nil
    }

    // MARK: - Persistence

    private func saveGame() {
        let saveData = GameSaveData(
            playerProfile: playerProfile,
            company: company,
            gameOutcome: gameOutcome,
            lastStartupSaleValue:
                lastStartupSaleValue
        )

        GameSaveManager.shared.save(
            saveData
        )
    }

    // MARK: - Founder Profile

    func createFounder(
        name: String
    ) {
        let cleanedName =
            name.trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        guard !cleanedName.isEmpty else {
            return
        }

        playerProfile.name =
            cleanedName

        saveGame()
    }

    // MARK: - Start New Game

    func startNewGame(
        companyName: String,
        industry: Industry,
        founderInvestment: Double
    ) {
        let cleanedName =
            companyName.trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        let safeInvestment =
            min(
                max(founderInvestment, 0),
                playerProfile.founderWealth
            )

        playerProfile.founderWealth -=
            safeInvestment

        playerProfile.totalMoneyInvested +=
            safeInvestment

        company = Company.newCompany(
            name: cleanedName,
            industry: industry
        )

        company.cash +=
            safeInvestment

        playerProfile.totalStartupsCreated += 1

        lastStartupSaleValue = 0
        gameOutcome = .active
        
        // TEMPORARY UNICORN TEST
//        self.company.marketValue = 1_000_000_000
//        self.gameOutcome = .active
//        updateGameOutcome()

        saveGame()
    }

    // MARK: - Startup Sale

    func sellStartup() {
        completeStartupSale(
            outcome: .sold
        )
    }

    private func completeStartupSale(
        outcome: GameOutcome
    ) {
        guard gameOutcome == .active else {
            return
        }

        let saleValue =
            company.marketValue

        lastStartupSaleValue =
            saleValue

        playerProfile.founderWealth +=
            saleValue

        playerProfile.totalMoneyEarnedFromSales +=
            saleValue

        playerProfile.startupsSold += 1

        if outcome == .unicorn {
            playerProfile.unicornsCreated += 1
        }

        gameOutcome =
            outcome

        saveGame()
    }

    // MARK: - Employees

    func hire(
        _ candidate: Employee
    ) -> Bool {
        var hiredEmployee =
            candidate

        hiredEmployee.hiredMonth =
            company.month

        company.cash -=
            candidate.hiringCost

        company.monthlyHiringSpend +=
            candidate.hiringCost

        company.employees.append(
            hiredEmployee
        )

        playerProfile.totalEmployeesHired += 1

        changeMorale(
            by: candidate.moraleImpact
        )

        saveGame()

        return true
    }

    func fire(
        _ employee: Employee
    ) -> Bool {
        let severanceCost =
            employee.severanceCost

        company.cash -=
            severanceCost

        company.monthlySeveranceSpend +=
            severanceCost

        company.employees.removeAll {
            $0.id == employee.id
        }

        playerProfile.totalEmployeesFired += 1

        changeMorale(
            by: -5
        )

        saveGame()

        return true
    }

    func canAfford(
        _ candidate: Employee
    ) -> Bool {
        let projectedCash =
            company.cash -
            candidate.hiringCost

        return projectedCash >
            bankruptcyLimit
    }

    // MARK: - Product Actions

    func fixBugs() {
        let cost = 2_000.0

        company.cash -=
            cost

        company.monthlyProductSpend +=
            cost

        changeProductQuality(
            by: 2
        )

        company.patchVersion += 1

        saveGame()
    }

    func developFeature() {
        let cost = 8_000.0

        company.cash -=
            cost

        company.monthlyProductSpend +=
            cost

        changeProductQuality(
            by: 6
        )

        company.minorVersion += 1
        company.patchVersion = 0

        saveGame()
    }

    func majorRelease() {
        let cost = 20_000.0

        company.cash -=
            cost

        company.monthlyProductSpend +=
            cost

        changeProductQuality(
            by: 15
        )

        company.majorVersion += 1
        company.minorVersion = 0
        company.patchVersion = 0

        saveGame()
    }

    // MARK: - Marketing

    func runOneTimeMarketingCampaign(
        _ campaign: MarketingCampaign
    ) {
        company.cash -=
            campaign.oneTimeCost

        company.monthlyMarketingSpend +=
            campaign.oneTimeCost

        let gain =
            campaign.generateOneTimeGain()

        changeBrandAwareness(
            by: gain
        )

        company.lastMarketingCampaign =
            campaign

        company.lastMarketingGain =
            gain

        company.lastMarketingWasSubscription =
            false

        saveGame()
    }

    func startMonthlyMarketingCampaign(
        _ campaign: MarketingCampaign
    ) {
        company.activeMonthlyMarketingCampaign =
            campaign

        saveGame()
    }

    func cancelMonthlyMarketingCampaign() {
        company.activeMonthlyMarketingCampaign =
            nil

        saveGame()
    }

    func isMarketingCampaignActive(
        _ campaign: MarketingCampaign
    ) -> Bool {
        company.activeMonthlyMarketingCampaign ==
            campaign
    }

    // MARK: - Advance Month

    func advanceMonth() -> MonthResult {
        
        debugPrintCompanyValues(
            title:
                "MONTH \(company.month) — BEFORE END-MONTH PROCESSING"
        )

        let debugStartingCash =
            company.cash

        let debugStartingRevenue =
            company.monthlyRevenue

        let debugStartingMarketValue =
            company.marketValue

        let debugStartingProduct =
            company.productQuality

        let debugStartingMorale =
            company.employeeMorale

        let debugStartingBrand =
            company.brandAwareness
        // end debug
        
        let completedMonth =
            company.month

        // MARK: Values Before Monthly Processing

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

        // MARK: Spending Already Made This Month

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

        // MARK: Employee Contributions

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

        // MARK: Monthly Company Changes

        processMonthlyMarketing()

        updateBrandAwarenessMaintenance()

        updateProductQuality()

        updateRevenue(
            contribution:
                revenueContribution
        )

        updateMorale()

        updateMarketValue(
            contribution:
                marketValueContribution
        )

        // MARK: Recurring Expenses

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

        company.cash +=
            monthlyProfit

        company.month += 1

        company.marketValueHistory.append(
            MarketValuePoint(
                month: company.month,
                value: company.marketValue
            )
        )

        updateGameOutcome()

        //debug
        debugPrintValueComparison(
            title:
                "END-OF-MONTH CALCULATION — MONTH \(completedMonth)",
            beforeCash:
                debugStartingCash,
            beforeRevenue:
                debugStartingRevenue,
            beforeMarketValue:
                debugStartingMarketValue,
            beforeProduct:
                debugStartingProduct,
            beforeMorale:
                debugStartingMorale,
            beforeBrand:
                debugStartingBrand
        )

        debugPrintCompanyValues(
            title:
                "MONTH \(completedMonth) FINISHED — NOW ENTERING MONTH \(company.month)"
        )
        
        
        
        // MARK: Month Result

        let result = MonthResult(
            completedMonth:
                completedMonth,

            previousCash:
                previousCash,
            newCash:
                company.cash,

            previousRevenue:
                previousRevenue,
            newRevenue:
                company.monthlyRevenue,

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
            
            eventTitle:
                company.lastEventTitle,
            eventChoiceTitle:
                company.lastEventChoiceTitle,

            eventCashChange:
                company.eventCashChangeThisMonth,
            eventRevenueChange:
                company.eventRevenueChangeThisMonth,
            eventMarketValueChange:
                company.eventMarketValueChangeThisMonth,

            eventProductChange:
                company.eventProductChangeThisMonth,
            eventMoraleChange:
                company.eventMoraleChangeThisMonth,
            eventBrandChange:
                company.eventBrandChangeThisMonth,

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

        // MARK: Prepare for Next Month

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

        saveGame()

        return result
    }
    
    
    // MARK: - Debug Value Tracking

    private func debugPrintCompanyValues(
        title: String
    ) {
        print("")
        print("==================================================")
        print(title)
        print("==================================================")
        print("MONTH: \(company.month)")
        print("CASH: \(debugMoney(company.cash))")
        print("MONTHLY REVENUE: \(debugMoney(company.monthlyRevenue))")
        print("MARKET VALUE: \(debugMoney(company.marketValue))")
        print("PRODUCT QUALITY: \(company.productQuality)%")
        print("EMPLOYEE MORALE: \(company.employeeMorale)%")
        print("BRAND AWARENESS: \(company.brandAwareness)%")
        print("==================================================")
        print("")
    }

    private func debugPrintEventChanges(
        eventTitle: String,
        choice: EventChoice
    ) {
        print("")
        print("--------------------------------------------------")
        print("EVENT SELECTED")
        print("--------------------------------------------------")
        print("EVENT: \(eventTitle)")
        print("CHOICE: \(choice.title)")
        print("")
        print("DECLARED EVENT CHANGES:")
        print("Cash: \(debugSignedMoney(choice.cashChange))")
        print("Monthly Revenue: \(debugSignedMoney(choice.revenueChange))")
        print("Market Value: \(debugSignedMoney(choice.marketValueChange))")
        print("Product Quality: \(debugSignedPercent(choice.productChange))")
        print("Employee Morale: \(debugSignedPercent(choice.moraleChange))")
        print("Brand Awareness: \(debugSignedPercent(choice.brandChange))")
        print("--------------------------------------------------")
        print("")
    }

    private func debugPrintValueComparison(
        title: String,
        beforeCash: Double,
        beforeRevenue: Double,
        beforeMarketValue: Double,
        beforeProduct: Int,
        beforeMorale: Int,
        beforeBrand: Int
    ) {
        print("")
        print("**************************************************")
        print(title)
        print("**************************************************")

        debugPrintComparisonRow(
            name: "Cash",
            before: beforeCash,
            after: company.cash
        )

        debugPrintComparisonRow(
            name: "Monthly Revenue",
            before: beforeRevenue,
            after: company.monthlyRevenue
        )

        debugPrintComparisonRow(
            name: "Market Value",
            before: beforeMarketValue,
            after: company.marketValue
        )

        debugPrintPercentComparisonRow(
            name: "Product Quality",
            before: beforeProduct,
            after: company.productQuality
        )

        debugPrintPercentComparisonRow(
            name: "Employee Morale",
            before: beforeMorale,
            after: company.employeeMorale
        )

        debugPrintPercentComparisonRow(
            name: "Brand Awareness",
            before: beforeBrand,
            after: company.brandAwareness
        )

        print("**************************************************")
        print("")
    }

    private func debugPrintComparisonRow(
        name: String,
        before: Double,
        after: Double
    ) {
        let difference =
            after - before

        print("\(name):")
        print("  Before: \(debugMoney(before))")
        print("  Change: \(debugSignedMoney(difference))")
        print("  After:  \(debugMoney(after))")
    }

    private func debugPrintPercentComparisonRow(
        name: String,
        before: Int,
        after: Int
    ) {
        let difference =
            after - before

        print("\(name):")
        print("  Before: \(before)%")
        print("  Change: \(debugSignedPercent(difference))")
        print("  After:  \(after)%")
    }

    private func debugMoney(
        _ amount: Double
    ) -> String {
        String(
            format: "$%.2f",
            amount
        )
    }

    private func debugSignedMoney(
        _ amount: Double
    ) -> String {
        let sign =
            amount >= 0 ? "+" : "-"

        return sign +
            String(
                format: "$%.2f",
                abs(amount)
            )
    }

    private func debugSignedPercent(
        _ amount: Int
    ) -> String {
        if amount >= 0 {
            return "+\(amount)%"
        }

        return "\(amount)%"
    }

    // MARK: - Events

    func generateMonthlyEvent() {
        guard gameOutcome == .active else {
            currentEvent = nil
            return
        }

        debugPrintCompanyValues(
            title:
                "BEGINNING OF MONTH \(company.month) — BEFORE EVENT"
        )

        currentEvent =
            GameEventManager.shared.randomEvent(
                for: company.stage
            )

        if let currentEvent {
            print(
                "Generated event for Month \(company.month): \(currentEvent.title)"
            )
        } else {
            print(
                "No event generated for Month \(company.month)"
            )
        }
    }

    
    func chooseEventOption(
        _ choice: EventChoice
    ) {
        guard gameOutcome == .active else {
            currentEvent = nil
            return
        }

        let eventTitle =
            currentEvent?.title ??
            "Unknown Event"

        let cashBeforeEvent =
            company.cash

        let revenueBeforeEvent =
            company.monthlyRevenue

        let marketValueBeforeEvent =
            company.marketValue

        let productBeforeEvent =
            company.productQuality

        let moraleBeforeEvent =
            company.employeeMorale

        let brandBeforeEvent =
            company.brandAwareness

        debugPrintEventChanges(
            eventTitle: eventTitle,
            choice: choice
        )

        company.cash +=
            choice.cashChange

        company.monthlyRevenue =
            max(
                0,
                company.monthlyRevenue +
                    choice.revenueChange
            )

        changeMorale(
            by: choice.moraleChange
        )

        changeProductQuality(
            by: choice.productChange
        )

        changeBrandAwareness(
            by: choice.brandChange
        )

        company.marketValue =
            max(
                0,
                company.marketValue +
                    choice.marketValueChange
            )

        debugPrintValueComparison(
            title:
                "ACTUAL EVENT RESULT — MONTH \(company.month)",
            beforeCash:
                cashBeforeEvent,
            beforeRevenue:
                revenueBeforeEvent,
            beforeMarketValue:
                marketValueBeforeEvent,
            beforeProduct:
                productBeforeEvent,
            beforeMorale:
                moraleBeforeEvent,
            beforeBrand:
                brandBeforeEvent
        )

        debugPrintCompanyValues(
            title:
                "MONTH \(company.month) — IMMEDIATELY AFTER EVENT"
        )

        currentEvent = nil

        updateGameOutcome()
        saveGame()
    }

    // MARK: - Game Outcome

    private func updateGameOutcome() {
        guard gameOutcome == .active else {
            return
        }

        if company.cash <=
            bankruptcyLimit {

            playerProfile.startupsBankrupt += 1

            gameOutcome =
                .bankrupt

        } else if company.marketValue >=
                    unicornTarget {

            completeStartupSale(
                outcome: .unicorn
            )
        }
    }

    // MARK: - Product Quality

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

    // MARK: - Monthly Marketing

    private func processMonthlyMarketing() {
        guard let campaign =
            company.activeMonthlyMarketingCampaign
        else {
            return
        }

        let gain =
            campaign.generateMonthlyGain()

        changeBrandAwareness(
            by: gain
        )

        company.lastMarketingCampaign =
            campaign

        company.lastMarketingGain =
            gain

        company.lastMarketingWasSubscription =
            true
    }

    private func updateBrandAwarenessMaintenance() {
        guard company.activeMonthlyMarketingCampaign ==
                nil
        else {
            return
        }

        changeBrandAwareness(
            by: -1
        )
    }

    // MARK: - Revenue

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

        company.monthlyRevenue =
            max(
                0,
                newRevenue
            )
    }

    // MARK: - Morale

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

        changeMorale(
            by: moraleChange
        )
    }

    // MARK: - Market Value

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
            contribution *
            15_000

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

        let targetValue =
            max(
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

        company.marketValue =
            max(
                0,
                company.marketValue +
                movementTowardTarget
            )
    }

    // MARK: - Percentage Changes

    private func changeProductQuality(
        by amount: Int
    ) {
        let previousQuality =
            company.productQuality

        company.productQuality =
            clampedPercentage(
                company.productQuality +
                amount
            )

        let actualChange =
            company.productQuality -
            previousQuality

        company.monthlyProductQualityChange +=
            actualChange
    }

    private func changeMorale(
        by amount: Int
    ) {
        let previousMorale =
            company.employeeMorale

        company.employeeMorale =
            clampedPercentage(
                company.employeeMorale +
                amount
            )

        let actualChange =
            company.employeeMorale -
            previousMorale

        company.monthlyMoraleChange +=
            actualChange
    }

    private func changeBrandAwareness(
        by amount: Int
    ) {
        let previousAwareness =
            company.brandAwareness

        company.brandAwareness =
            clampedPercentage(
                company.brandAwareness +
                amount
            )

        let actualChange =
            company.brandAwareness -
            previousAwareness

        company.monthlyBrandAwarenessChange +=
            actualChange
    }

    private func clampedPercentage(
        _ value: Int
    ) -> Int {
        min(
            max(value, 0),
            100
        )
    }
}
