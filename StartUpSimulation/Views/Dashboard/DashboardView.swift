//
//  DashboardView.swift
//  StartUpSimulation
//
//  Created by Talya Benatar on 15/07/2026.
//

import SwiftUI
import Charts

struct DashboardView: View {
    let onReturnToMainMenu: () -> Void
    
    @EnvironmentObject private var gameViewModel: GameViewModel
    
    @State private var showEmployees = false
    @State private var showProduct = false
    @State private var showMarketing = false
    @State private var monthResult: MonthResult?
    @State private var showMonthSummary = false
    @State private var showGameOver = false
    @State private var showSellConfirmation = false
    @State private var showFinance = false

    
    private let gridColumns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        let company = gameViewModel.company

        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.08, green: 0.10, blue: 0.18),
                    Color(red: 0.12, green: 0.20, blue: 0.32)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 22) {
                    companyHeader(company: company)

                    stageCard(company: company)

                    LazyVGrid(columns: gridColumns, spacing: 12) {
                        DashboardStatCard(
                            title: "Cash",
                            value: formatCurrency(company.cash),
                            icon: "dollarsign.circle.fill",
                            color: .green
                        )

                        DashboardStatCard(
                            title: "Market Value",
                            value: formatCurrency(company.marketValue),
                            icon: "chart.line.uptrend.xyaxis",
                            color: .blue
                        )

                        DashboardStatCard(
                            title: "Revenue",
                            value: formatCurrency(company.monthlyRevenue),
                            icon: "arrow.up.circle.fill",
                            color: .green
                        )

                        DashboardStatCard(
                            title: "Expenses",
                            value: formatCurrency(company.monthlyExpenses),
                            icon: "arrow.down.circle.fill",
                            color: .red
                        )

                        DashboardStatCard(
                            title: "Product",
                            value: "\(company.productQuality)%",
                            icon: "star.fill",
                            color: .yellow
                        )

                        DashboardStatCard(
                            title: "Morale",
                            value: "\(company.employeeMorale)%",
                            icon: "face.smiling.fill",
                            color: .orange
                        )
                    }

                    marketValueChart

                    quickActions

                    endMonthButton
                    
                    sellStartupButton
                }
                .padding(.horizontal, 18)
                .padding(.top, 14)
                .padding(.bottom, 30)
            }
        }
        
        .navigationBarBackButtonHidden(true)
        
        .navigationDestination(isPresented: $showEmployees) {
                    EmployeesView()
                        .environmentObject(gameViewModel)
                }
        
        .navigationDestination(isPresented: $showProduct) {
            ProductView()
                .environmentObject(gameViewModel)
        }
        
        .navigationDestination(isPresented: $showMarketing) {
            MarketingView(
                gameViewModel: gameViewModel
            )
        }
        
        .navigationDestination(isPresented: $showFinance) {
            FinanceView()
                .environmentObject(gameViewModel)
        }
        
        .sheet(isPresented: $showMonthSummary) {
            if let monthResult {
                MonthSummaryView(result: monthResult)
            }
        }
        
        .fullScreenCover(isPresented: $showGameOver) {
            GameOverView(
                onReturnToMainMenu: {
                    showGameOver = false
                    onReturnToMainMenu()
                }
            )
            .environmentObject(gameViewModel)
        }
        .confirmationDialog(
            "Sell Startup",
            isPresented: $showSellConfirmation,
            titleVisibility: .visible
        ) {

            Button("Sell for \(formatCurrency(gameViewModel.company.marketValue))") {
                gameViewModel.sellStartup()
                showGameOver = true
            }

            Button("Cancel", role: .cancel) { }

        } message: {
            Text("Selling your startup ends the current game. The sale value will be added to your founder wealth.")
        }
        
        
    }
    
    

    private func companyHeader(company: Company) -> some View {
        VStack(spacing: 6) {
            Image(systemName: company.industry.iconName)
                .font(.system(size: 46))
                .foregroundColor(.green)
                .frame(width: 82, height: 82)
                .background(
                    Circle()
                        .fill(Color.green.opacity(0.15))
                )

            Text(company.name)
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            Text(company.industry.rawValue)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.65))

            HStack(spacing: 6) {
                Image(systemName: "calendar")
                Text("Month \(company.month)")
            }
            .font(.subheadline.weight(.semibold))
            .foregroundColor(.green)
        }
    }

    private func stageCard(company: Company) -> some View {
        HStack(spacing: 14) {
            Image(systemName: "flag.fill")
                .font(.title2)
                .foregroundColor(.green)

            VStack(alignment: .leading, spacing: 4) {
                Text(company.stage.rawValue)
                    .font(.headline)
                    .foregroundColor(.white)

                Text(company.stage.nextGoalDescription)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.65))
            }

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.10))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.green.opacity(0.4), lineWidth: 1)
        )
    }

    private var marketValueChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Market Value Over Time")
                    .font(.headline)
                    .foregroundColor(.white)

                Spacer()

                Image(systemName: "chart.xyaxis.line")
                    .foregroundColor(.green)
            }

            if gameViewModel.company.marketValueHistory.count < 2 {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.black.opacity(0.18))
                        .frame(height: 150)

                    VStack(spacing: 8) {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.title)
                            .foregroundColor(.green.opacity(0.8))

                        Text("Complete a month to begin the chart")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.55))
                    }
                }
            } else {
                Chart(gameViewModel.company.marketValueHistory) { point in
                    LineMark(
                        x: .value("Month", point.month),
                        y: .value("Market Value", point.value)
                    )
                    .foregroundStyle(.green)
                    .interpolationMethod(.catmullRom)

                    AreaMark(
                        x: .value("Month", point.month),
                        y: .value("Market Value", point.value)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color.green.opacity(0.35),
                                Color.green.opacity(0.02)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                    PointMark(
                        x: .value("Month", point.month),
                        y: .value("Market Value", point.value)
                    )
                    .foregroundStyle(.green)
                }
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: 5)) { value in
                        AxisGridLine()
                            .foregroundStyle(Color.white.opacity(0.08))

                        AxisTick()
                            .foregroundStyle(Color.white.opacity(0.3))

                        AxisValueLabel {
                            if let month = value.as(Int.self) {
                                Text("M\(month)")
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        }
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisGridLine()
                            .foregroundStyle(Color.white.opacity(0.08))

                        AxisValueLabel {
                            if let amount = value.as(Double.self) {
                                Text(formatCurrency(amount))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        }
                    }
                }
                .frame(height: 180)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.08))
        )
    }

    private var quickActions: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Manage Startup")
                .font(.headline)
                .foregroundColor(.white)

            LazyVGrid(columns: gridColumns, spacing: 12) {
                DashboardActionButton(
                    title: "Employees",
                    icon: "person.3.fill",
                    color: .purple
                ) {
                    showEmployees = true
                }

                DashboardActionButton(
                    title: "Product",
                    icon: "shippingbox.fill",
                    color: .yellow
                ) {
                    showProduct = true
                }

                DashboardActionButton(
                    title: "Marketing",
                    icon: "megaphone.fill",
                    color: .orange
                ) {
                    showMarketing = true
                }

                DashboardActionButton(
                    title: "Finance",
                    icon: "banknote.fill",
                    color: .green
                ) {
                    showFinance = true
                }
            }
        }
    }

    private var endMonthButton: some View {
        Button {
            monthResult = gameViewModel.advanceMonth()

            if gameViewModel.gameOutcome == .active {
                showMonthSummary = true
            } else {
                showGameOver = true
            }
        } label: {
            HStack {
                Image(systemName: "calendar.badge.clock")

                Text("End Month")
                    .fontWeight(.bold)

                Spacer()

                Image(systemName: "arrow.right")
            }
            .foregroundColor(.black)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.green)
            )
        }
        .padding(.top, 4)
    }
    
    private var sellStartupButton: some View {
        Button {
            showSellConfirmation = true
        } label: {
            HStack {
                Image(systemName: "building.2.fill")

                Text("Sell Startup")
                    .fontWeight(.bold)

                Spacer()

                Text(formatCurrency(gameViewModel.company.marketValue))
                    .font(.subheadline.bold())
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.orange)
            )
        }
    }
    

    private func formatCurrency(_ amount: Double) -> String {
        if amount >= 1_000_000_000 {
            return String(format: "$%.1fB", amount / 1_000_000_000)
        }

        if amount >= 1_000_000 {
            return String(format: "$%.1fM", amount / 1_000_000)
        }

        if amount >= 1_000 {
            return String(format: "$%.0fK", amount / 1_000)
        }

        return "$\(Int(amount))"
    }
}

struct DashboardStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)

                Spacer()
            }

            Text(value)
                .font(.title3.bold())
                .foregroundColor(.white)

            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity, minHeight: 88, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.10))
        )
    }
}

struct DashboardActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(color)

                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white.opacity(0.10))
            )
        }
    }
}

struct MonthSummaryView: View {
    @Environment(\.dismiss) private var dismiss

    let result: MonthResult

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(
                        red: 0.08,
                        green: 0.10,
                        blue: 0.18
                    ),
                    Color(
                        red: 0.12,
                        green: 0.20,
                        blue: 0.32
                    )
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 22) {
                    header

                    financialSummary

                    recurringExpensesSection

                    if result.totalOneTimeSpending > 0 {
                        oneTimeSpendingSection
                    }

                    companyChangesSection

                    continueButton
                }
                .padding(24)
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: 10) {
            Image(
                systemName:
                    result.netFinancialResult >= 0
                    ? "chart.line.uptrend.xyaxis.circle.fill"
                    : "chart.line.downtrend.xyaxis.circle.fill"
            )
            .font(.system(size: 54))
            .foregroundColor(
                result.netFinancialResult >= 0
                ? .green
                : .red
            )

            Text(
                "Month \(result.completedMonth) Complete"
            )
            .font(.largeTitle.bold())
            .foregroundColor(.white)
            .multilineTextAlignment(.center)

            Text(summaryMessage)
                .font(.subheadline)
                .foregroundColor(
                    .white.opacity(0.65)
                )
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Financial Summary

    private var financialSummary: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle(
                title: "Financial Result",
                icon: "dollarsign.circle.fill"
            )

            resultRow(
                title: "Monthly Revenue",
                value: formatCurrency(
                    result.newRevenue
                ),
                detail: formatSignedCurrency(
                    result.revenueChange
                ),
                detailIsPositive:
                    result.revenueChange >= 0
            )

            resultRow(
                title: "Recurring Expenses",
                value: formatCurrency(
                    result.totalRecurringExpenses
                )
            )

            resultRow(
                title: "Recurring Profit",
                value: formatSignedCurrency(
                    result.monthlyProfit
                ),
                detailIsPositive:
                    result.monthlyProfit >= 0
            )

            if result.totalOneTimeSpending > 0 {
                resultRow(
                    title: "One-Time Spending",
                    value:
                        "-\(formatCurrency(result.totalOneTimeSpending))",
                    detailIsPositive: false
                )
            }

            Divider()
                .overlay(
                    Color.white.opacity(0.15)
                )

            resultRow(
                title: "Total Cash Change",
                value: formatSignedCurrency(
                    result.cashChange
                ),
                detailIsPositive:
                    result.cashChange >= 0,
                isHighlighted: true
            )

            resultRow(
                title: "Current Cash",
                value: formatCurrency(
                    result.newCash
                ),
                isHighlighted: true
            )
        }
        .financeCard()
    }

    // MARK: - Recurring Expenses

    private var recurringExpensesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle(
                title: "Recurring Expenses",
                icon: "repeat.circle.fill"
            )

            resultRow(
                title: "Operating Costs",
                value:
                    "-\(formatCurrency(result.operatingExpenses))"
            )

            resultRow(
                title: "Employee Salaries",
                value:
                    "-\(formatCurrency(result.salaryExpenses))"
            )

            resultRow(
                title: "Marketing Subscription",
                value:
                    "-\(formatCurrency(result.marketingSubscriptionExpenses))"
            )

            Divider()
                .overlay(
                    Color.white.opacity(0.15)
                )

            resultRow(
                title: "Total Each Month",
                value:
                    "-\(formatCurrency(result.totalRecurringExpenses))",
                isHighlighted: true
            )
        }
        .financeCard()
    }

    // MARK: - One-Time Spending

    private var oneTimeSpendingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle(
                title: "One-Time Spending",
                icon: "cart.fill"
            )

            if result.productSpending > 0 {
                resultRow(
                    title: "Product Development",
                    value:
                        "-\(formatCurrency(result.productSpending))"
                )
            }

            if result.hiringSpending > 0 {
                resultRow(
                    title: "Hiring Costs",
                    value:
                        "-\(formatCurrency(result.hiringSpending))"
                )
            }

            if result.severanceSpending > 0 {
                resultRow(
                    title: "Severance Costs",
                    value:
                        "-\(formatCurrency(result.severanceSpending))"
                )
            }

            if result.oneTimeMarketingSpending > 0 {
                resultRow(
                    title: "Marketing Campaigns",
                    value:
                        "-\(formatCurrency(result.oneTimeMarketingSpending))"
                )
            }

            Divider()
                .overlay(
                    Color.white.opacity(0.15)
                )

            resultRow(
                title: "Total One-Time Spending",
                value:
                    "-\(formatCurrency(result.totalOneTimeSpending))",
                isHighlighted: true
            )
        }
        .financeCard()
    }

    // MARK: - Company Changes

    private var companyChangesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle(
                title: "Company Changes",
                icon: "building.2.fill"
            )

            percentageRow(
                title: "Product Quality",
                value: result.newProductQuality,
                change:
                    result.productQualityChange
            )

            percentageRow(
                title: "Team Morale",
                value: result.newMorale,
                change:
                    result.moraleChange
            )

            percentageRow(
                title: "Brand Awareness",
                value:
                    result.newBrandAwareness,
                change:
                    result.brandAwarenessChange
            )

            resultRow(
                title: "Market Value",
                value: formatCurrency(
                    result.newMarketValue
                ),
                detail: formatSignedCurrency(
                    result.marketValueChange
                ),
                detailIsPositive:
                    result.marketValueChange >= 0
            )
        }
        .financeCard()
    }

    // MARK: - Continue

    private var continueButton: some View {
        Button {
            dismiss()
        } label: {
            Text(
                "Continue to Month \(result.completedMonth + 1)"
            )
            .font(.headline)
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(
                    cornerRadius: 16
                )
                .fill(Color.green)
            )
        }
    }

    // MARK: - Reusable Views

    private func sectionTitle(
        title: String,
        icon: String
    ) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(.green)

            Text(title)
                .font(.headline)
                .foregroundColor(.white)
        }
    }

    private func resultRow(
        title: String,
        value: String,
        detail: String? = nil,
        detailIsPositive: Bool = true,
        isHighlighted: Bool = false
    ) -> some View {
        HStack {
            Text(title)
                .font(
                    isHighlighted
                    ? .subheadline.bold()
                    : .subheadline
                )
                .foregroundColor(
                    isHighlighted
                    ? .white
                    : .white.opacity(0.7)
                )

            Spacer()

            if let detail {
                Text(detail)
                    .font(.caption.bold())
                    .foregroundColor(
                        detailIsPositive
                        ? .green
                        : .red
                    )
            }

            Text(value)
                .font(
                    isHighlighted
                    ? .headline
                    : .subheadline.bold()
                )
                .foregroundColor(
                    value.hasPrefix("-")
                    ? .red
                    : .white
                )
        }
    }

    private func percentageRow(
        title: String,
        value: Int,
        change: Int
    ) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(
                    .white.opacity(0.7)
                )

            Spacer()

            Text(
                "\(change >= 0 ? "+" : "")\(change)%"
            )
            .font(.caption.bold())
            .foregroundColor(
                change >= 0
                ? .green
                : .red
            )

            Text("\(value)%")
                .font(.subheadline.bold())
                .foregroundColor(.white)
                .frame(width: 45, alignment: .trailing)
        }
    }

    // MARK: - Messages

    private var summaryMessage: String {
        if result.netFinancialResult > 0 {
            return """
            The company ended the month with positive cash flow. The financial spreadsheet is smiling.
            """
        }

        if result.netFinancialResult == 0 {
            return """
            The company broke even after all spending. Suspiciously balanced.
            """
        }

        if result.monthlyProfit >= 0 &&
            result.netFinancialResult < 0 {
            return """
            Regular operations were profitable, but one-time investments reduced cash this month.
            """
        }

        return """
        The company spent more than it earned. Review revenue, salaries, marketing, and operating costs.
        """
    }

    // MARK: - Formatting

    private func formatCurrency(
        _ amount: Double
    ) -> String {
        let absoluteAmount = abs(amount)

        if absoluteAmount >=
            1_000_000_000 {
            return String(
                format: "$%.1fB",
                absoluteAmount /
                    1_000_000_000
            )
        }

        if absoluteAmount >=
            1_000_000 {
            return String(
                format: "$%.1fM",
                absoluteAmount /
                    1_000_000
            )
        }

        if absoluteAmount >= 1_000 {
            return String(
                format: "$%.0fK",
                absoluteAmount / 1_000
            )
        }

        return "$\(Int(absoluteAmount))"
    }

    private func formatSignedCurrency(
        _ amount: Double
    ) -> String {
        let sign =
            amount >= 0 ? "+" : "-"

        return sign +
            formatCurrency(abs(amount))
    }
}

private extension View {
    func financeCard() -> some View {
        self
            .padding()
            .background(
                RoundedRectangle(
                    cornerRadius: 18
                )
                .fill(
                    Color.white.opacity(0.09)
                )
            )
    }
}




struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DashboardView(
                onReturnToMainMenu: {}
            )
                .environmentObject(
                    GameViewModel(
                        company: Company.newCompany(
                            name: "Nebula Labs",
                            industry: .artificialIntelligence
                        )
                    )
                )
        }
    }
}
