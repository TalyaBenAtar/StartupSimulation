//
//  FinanceView.swift
//  StartUpSimulation
//
//  Created by Talya Benatar on 18/07/2026.
//

import SwiftUI

struct FinanceView: View {
    @EnvironmentObject private var gameViewModel: GameViewModel

    private var company: Company {
        gameViewModel.company
    }

    private var finance: FinanceSnapshot {
        FinanceSnapshot(
            company: company,
            bankruptcyLimit:
                gameViewModel.bankruptcyLimit
        )
    }

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
                VStack(spacing: 20) {
                    header

                    financialStatusCard

                    currentPositionSection

                    runwaySection

                    revenueForecastSection

                    recurringExpensesSection

                    if finance.totalOneTimeSpending > 0 {
                        oneTimeSpendingSection
                    }

                    financialAdviceSection
                }
                .padding(.horizontal, 18)
                .padding(.top, 14)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Finance")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: 8) {
            Image(systemName: "banknote.fill")
                .font(.system(size: 50))
                .foregroundColor(.green)
                .frame(
                    width: 90,
                    height: 90
                )
                .background(
                    Circle()
                        .fill(
                            Color.green.opacity(0.15)
                        )
                )

            Text("Financial Center")
                .font(.system(
                    size: 30,
                    weight: .bold
                ))
                .foregroundColor(.white)

            Text(
                """
                Understand where money comes from, where it goes, and what is likely to happen next month.
                """
            )
            .font(.subheadline)
            .foregroundColor(
                .white.opacity(0.65)
            )
            .multilineTextAlignment(.center)
        }
    }

    // MARK: - Financial Status

    private var financialStatusCard: some View {
        HStack(spacing: 14) {
            Image(
                systemName: statusIcon
            )
            .font(.title2)
            .foregroundColor(statusColor)

            VStack(
                alignment: .leading,
                spacing: 5
            ) {
                Text(
                    finance.financialStatus.title
                )
                .font(.headline)
                .foregroundColor(.white)

                Text(
                    finance.financialStatus
                        .explanation
                )
                .font(.caption)
                .foregroundColor(
                    .white.opacity(0.65)
                )
            }

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(
                cornerRadius: 18
            )
            .fill(statusColor.opacity(0.13))
        )
        .overlay(
            RoundedRectangle(
                cornerRadius: 18
            )
            .stroke(
                statusColor.opacity(0.5),
                lineWidth: 1
            )
        )
    }

    // MARK: - Current Position

    private var currentPositionSection: some View {
        VStack(
            alignment: .leading,
            spacing: 14
        ) {
            sectionTitle(
                title: "Current Position",
                icon: "dollarsign.circle.fill"
            )

            financeRow(
                title: "Current Cash",
                value: formatCurrency(
                    finance.currentCash
                ),
                explanation:
                    "Money currently available to operate and invest."
            )

            financeRow(
                title: "Monthly Revenue",
                value: formatCurrency(
                    finance.currentRevenue
                ),
                explanation:
                    "Expected customer income during the current month."
            )

            financeRow(
                title: "Recurring Expenses",
                value:
                    "-\(formatCurrency(finance.totalRecurringExpenses))",
                explanation:
                    "Costs that return every month."
            )

            Divider()
                .overlay(
                    Color.white.opacity(0.15)
                )

            financeRow(
                title: "Current Monthly Profit",
                value: formatSignedCurrency(
                    finance.currentMonthlyProfit
                ),
                explanation:
                    finance.currentMonthlyProfit >= 0
                    ? "Current revenue covers recurring expenses."
                    : "The company currently spends more each month than it earns.",
                highlighted: true
            )

            financeRow(
                title: "Bankruptcy Limit",
                value: formatCurrency(
                    finance.bankruptcyLimit
                ),
                explanation:
                    "The game ends when company cash reaches this amount."
            )
        }
        .financeSectionCard()
    }

    // MARK: - Runway

    private var runwaySection: some View {
        VStack(
            alignment: .leading,
            spacing: 14
        ) {
            sectionTitle(
                title: "Runway Forecast",
                icon: "calendar.badge.clock"
            )

            if finance.projectedMonthlyProfit >= 0 {
                Text("No immediate runway limit")
                    .font(.title3.bold())
                    .foregroundColor(.green)

                Text(
                    """
                    The projected monthly result is profitable, so cash should grow instead of moving toward bankruptcy.
                    """
                )
                .font(.subheadline)
                .foregroundColor(
                    .white.opacity(0.65)
                )
            } else {
                Text(runwayText)
                    .font(.title3.bold())
                    .foregroundColor(statusColor)

                Text(
                    """
                    This estimate uses projected revenue and recurring monthly expenses. New purchases, hiring, firing, and events can shorten the runway.
                    """
                )
                .font(.subheadline)
                .foregroundColor(
                    .white.opacity(0.65)
                )

                runwayProgressBar
            }

            Divider()
                .overlay(
                    Color.white.opacity(0.15)
                )

            financeRow(
                title: "Projected Monthly Result",
                value: formatSignedCurrency(
                    finance.projectedMonthlyProfit
                ),
                explanation:
                    "Expected revenue next month minus recurring expenses."
            )
        }
        .financeSectionCard()
    }

    private var runwayProgressBar: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(
                        Color.white.opacity(0.12)
                    )
                    .frame(height: 10)

                Capsule()
                    .fill(statusColor)
                    .frame(
                        width:
                            geometry.size.width *
                            runwayProgress,
                        height: 10
                    )
            }
        }
        .frame(height: 10)
    }

    // MARK: - Revenue Forecast

    private var revenueForecastSection: some View {
        VStack(
            alignment: .leading,
            spacing: 14
        ) {
            sectionTitle(
                title: "Revenue Forecast",
                icon:
                    "chart.line.uptrend.xyaxis"
            )

            Text(
                """
                The next month’s revenue is calculated from the company’s real performance. No random cash changes are included.
                """
            )
            .font(.caption)
            .foregroundColor(
                .white.opacity(0.6)
            )

            financeRow(
                title: "Current Revenue",
                value: formatCurrency(
                    finance.currentRevenue
                ),
                explanation:
                    "The starting revenue before this month’s growth and losses."
            )

            contributionRow(
                title: "Employee Growth",
                amount:
                    finance.employeeRevenueGrowth,
                explanation:
                    "Revenue contribution from employees, strengthened by product quality."
            )

            contributionRow(
                title: "Product Quality",
                amount:
                    finance.productQualityEffect,
                explanation:
                    company.productQuality >= 50
                    ? "Product quality is helping customer retention and growth."
                    : "Low product quality is causing customer loss."
            )

            contributionRow(
                title: "Brand Awareness",
                amount:
                    finance.brandAwarenessEffect,
                explanation:
                    company.brandAwareness >= 50
                    ? "Strong awareness helps attract customers."
                    : "Low awareness limits customer acquisition."
            )

            contributionRow(
                title: "Team Morale",
                amount:
                    finance.moraleEffect,
                explanation:
                    company.employees.isEmpty
                    ? "Morale has no effect because there are no employees."
                    : "Team morale affects productivity and customer growth."
            )

            if finance.missingTeamPenalty > 0 {
                contributionRow(
                    title: "No-Team Penalty",
                    amount:
                        -finance.missingTeamPenalty,
                    explanation:
                        "The founder cannot maintain product, support, and sales alone forever."
                )
            }

            Divider()
                .overlay(
                    Color.white.opacity(0.15)
                )

            financeRow(
                title: "Projected Revenue",
                value: formatCurrency(
                    finance.projectedNextRevenue
                ),
                explanation:
                    "Estimated revenue after applying all visible factors.",
                highlighted: true
            )
        }
        .financeSectionCard()
    }

    // MARK: - Recurring Expenses

    private var recurringExpensesSection: some View {
        VStack(
            alignment: .leading,
            spacing: 14
        ) {
            sectionTitle(
                title: "Recurring Expenses",
                icon: "repeat.circle.fill"
            )

            financeRow(
                title: "Operating Costs",
                value:
                    "-\(formatCurrency(finance.operatingExpenses))",
                explanation:
                    "Hosting, software, legal services, administration, and basic company operations."
            )

            financeRow(
                title: "Employee Salaries",
                value:
                    "-\(formatCurrency(finance.salaryExpenses))",
                explanation:
                    "\(company.employeeCount) employee\(company.employeeCount == 1 ? "" : "s") paid every month."
            )

            financeRow(
                title: "Marketing Subscription",
                value:
                    "-\(formatCurrency(finance.marketingSubscriptionExpenses))",
                explanation:
                    activeMarketingExplanation
            )

            Divider()
                .overlay(
                    Color.white.opacity(0.15)
                )

            financeRow(
                title: "Total Every Month",
                value:
                    "-\(formatCurrency(finance.totalRecurringExpenses))",
                explanation:
                    "This amount is deducted whenever you end a month.",
                highlighted: true
            )
        }
        .financeSectionCard()
    }

    // MARK: - One-Time Spending

    private var oneTimeSpendingSection: some View {
        VStack(
            alignment: .leading,
            spacing: 14
        ) {
            sectionTitle(
                title: "Spent This Month",
                icon: "cart.fill"
            )

            Text(
                """
                These costs were already removed from cash when you performed each action. They will not be charged again at the end of the month.
                """
            )
            .font(.caption)
            .foregroundColor(
                .white.opacity(0.6)
            )

            if finance.productSpending > 0 {
                financeRow(
                    title: "Product Development",
                    value:
                        "-\(formatCurrency(finance.productSpending))",
                    explanation:
                        "Bug fixes, features, and major product releases."
                )
            }

            if finance.oneTimeMarketingSpending > 0 {
                financeRow(
                    title: "One-Time Marketing",
                    value:
                        "-\(formatCurrency(finance.oneTimeMarketingSpending))",
                    explanation:
                        "Marketing campaigns purchased during this month."
                )
            }

            if finance.hiringSpending > 0 {
                financeRow(
                    title: "Hiring Costs",
                    value:
                        "-\(formatCurrency(finance.hiringSpending))",
                    explanation:
                        "Recruitment and onboarding costs for new employees."
                )
            }

            if finance.severanceSpending > 0 {
                financeRow(
                    title: "Severance",
                    value:
                        "-\(formatCurrency(finance.severanceSpending))",
                    explanation:
                        "One-time payments made when employees were fired."
                )
            }

            Divider()
                .overlay(
                    Color.white.opacity(0.15)
                )

            financeRow(
                title: "Total One-Time Spending",
                value:
                    "-\(formatCurrency(finance.totalOneTimeSpending))",
                explanation:
                    "Total optional investments and employee-related costs this month.",
                highlighted: true
            )
        }
        .financeSectionCard()
    }

    // MARK: - Advice

    private var financialAdviceSection: some View {
        VStack(
            alignment: .leading,
            spacing: 14
        ) {
            sectionTitle(
                title: "Financial Analysis",
                icon: "lightbulb.fill"
            )

            ForEach(
                financialAdvice,
                id: \.self
            ) { advice in
                HStack(
                    alignment: .top,
                    spacing: 10
                ) {
                    Image(
                        systemName:
                            "checkmark.circle.fill"
                    )
                    .foregroundColor(.green)
                    .padding(.top, 2)

                    Text(advice)
                        .font(.subheadline)
                        .foregroundColor(
                            .white.opacity(0.75)
                        )
                }
            }
        }
        .financeSectionCard()
    }

    // MARK: - Advice Logic

    private var financialAdvice: [String] {
        var advice: [String] = []

        if company.productQuality < 40 {
            advice.append(
                """
                Product quality is below 40%. Improving the product can reduce customer loss and strengthen employee-generated revenue.
                """
            )
        }

        if company.brandAwareness < 40 {
            advice.append(
                """
                Brand awareness is below 40%. Marketing can improve future revenue, but monthly campaigns also increase recurring expenses.
                """
            )
        }

        if company.employees.isEmpty {
            advice.append(
                """
                The company has no employees, causing an 8% monthly revenue penalty. Hiring can remove this penalty, but salaries become recurring costs.
                """
            )
        }

        if finance.salaryExpenses >
            finance.currentRevenue * 0.7 &&
            company.employeeCount > 0 {
            advice.append(
                """
                Salaries consume more than 70% of current revenue. Additional hiring could make the company financially unstable.
                """
            )
        }

        if finance.marketingSubscriptionExpenses > 0 &&
            finance.projectedMonthlyProfit < 0 {
            advice.append(
                """
                The active marketing subscription contributes to the monthly loss. Keep it only when its awareness growth justifies the shorter runway.
                """
            )
        }

        if company.cash < 0 {
            advice.append(
                """
                The company is operating in debt. Debt is allowed until \(formatCurrency(gameViewModel.bankruptcyLimit)), but further spending reduces the time available to recover.
                """
            )
        }

        if finance.projectedMonthlyProfit > 0 {
            advice.append(
                """
                The company is projected to generate positive monthly cash flow. This may be a safer time for product investment, marketing, or hiring.
                """
            )
        }

        if advice.isEmpty {
            advice.append(
                """
                The company is currently balanced. Compare the expected revenue benefit of each decision against its immediate and recurring costs.
                """
            )
        }

        return advice
    }

    // MARK: - Helpers

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

    private func financeRow(
        title: String,
        value: String,
        explanation: String,
        highlighted: Bool = false
    ) -> some View {
        VStack(
            alignment: .leading,
            spacing: 5
        ) {
            HStack {
                Text(title)
                    .font(
                        highlighted
                        ? .subheadline.bold()
                        : .subheadline
                    )
                    .foregroundColor(
                        highlighted
                        ? .white
                        : .white.opacity(0.75)
                    )

                Spacer()

                Text(value)
                    .font(
                        highlighted
                        ? .headline
                        : .subheadline.bold()
                    )
                    .foregroundColor(
                        value.hasPrefix("-")
                        ? .red
                        : .white
                    )
            }

            Text(explanation)
                .font(.caption)
                .foregroundColor(
                    .white.opacity(0.5)
                )
        }
    }

    private func contributionRow(
        title: String,
        amount: Double,
        explanation: String
    ) -> some View {
        VStack(
            alignment: .leading,
            spacing: 5
        ) {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(
                        .white.opacity(0.75)
                    )

                Spacer()

                Text(
                    formatSignedCurrency(amount)
                )
                .font(.subheadline.bold())
                .foregroundColor(
                    amount >= 0
                    ? .green
                    : .red
                )
            }

            Text(explanation)
                .font(.caption)
                .foregroundColor(
                    .white.opacity(0.5)
                )
        }
    }

    private var activeMarketingExplanation: String {
        guard let campaign =
            company.activeMonthlyMarketingCampaign
        else {
            return """
            No recurring marketing campaign is currently active.
            """
        }

        return """
        \(campaign.name) is active and will be charged every month until canceled.
        """
    }

    private var runwayText: String {
        guard let months =
            finance.estimatedRunwayMonths
        else {
            return "No immediate runway limit"
        }

        if months < 1 {
            return "Less than 1 month remaining"
        }

        return String(
            format:
                "%.1f months until bankruptcy",
            months
        )
    }

    private var runwayProgress: CGFloat {
        guard let months =
            finance.estimatedRunwayMonths
        else {
            return 1
        }

        return CGFloat(
            min(max(months / 12, 0), 1)
        )
    }

    private var statusColor: Color {
        switch finance.financialStatus {
        case .profitable:
            return .green

        case .stable:
            return .blue

        case .risky:
            return .orange

        case .critical:
            return .red
        }
    }

    private var statusIcon: String {
        switch finance.financialStatus {
        case .profitable:
            return "chart.line.uptrend.xyaxis"

        case .stable:
            return "checkmark.shield.fill"

        case .risky:
            return "exclamationmark.triangle.fill"

        case .critical:
            return "creditcard.trianglebadge.exclamationmark"
        }
    }

    private func formatCurrency(
        _ amount: Double
    ) -> String {
        let sign =
            amount < 0 ? "-" : ""

        let absoluteAmount =
            abs(amount)

        if absoluteAmount >=
            1_000_000_000 {
            return sign + String(
                format: "$%.1fB",
                absoluteAmount /
                    1_000_000_000
            )
        }

        if absoluteAmount >=
            1_000_000 {
            return sign + String(
                format: "$%.1fM",
                absoluteAmount /
                    1_000_000
            )
        }

        if absoluteAmount >= 1_000 {
            return sign + String(
                format: "$%.0fK",
                absoluteAmount / 1_000
            )
        }

        return sign +
            "$\(Int(absoluteAmount))"
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

// MARK: - Card Style

private extension View {
    func financeSectionCard() -> some View {
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

// MARK: - Preview

struct FinanceView_Previews:
    PreviewProvider {

    static var previews: some View {
        NavigationStack {
            FinanceView()
                .environmentObject(
                    GameViewModel(
                        company:
                            Company.newCompany(
                                name:
                                    "Nebula Labs",
                                industry:
                                    .artificialIntelligence
                            )
                    )
                )
        }
    }
}
