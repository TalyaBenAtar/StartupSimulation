//
//  FounderView.swift
//  StartUpSimulation
//
//  Created by Talya Benatar on 18/07/2026.
//

import SwiftUI
import Charts

struct FounderView: View {

    @EnvironmentObject private var gameViewModel:
        GameViewModel

    private let statisticColumns = [
        GridItem(
            .flexible(),
            spacing: 12
        ),
        GridItem(
            .flexible(),
            spacing: 12
        )
    ]

    var body: some View {
        ZStack {
            backgroundGradient

            ScrollView {
                VStack(spacing: 22) {
                    founderHeader

                    currentStartupCard

                    financialSummarySection

                    businessJourneyChart

                    teamManagementChart

                    investmentReturnChart
                }
                .padding(
                    .horizontal,
                    18
                )
                .padding(
                    .top,
                    14
                )
                .padding(
                    .bottom,
                    30
                )
            }
        }
        .navigationTitle(
            "Founder Profile"
        )
        .navigationBarTitleDisplayMode(
            .inline
        )
        .toolbarBackground(
            Color(
                red: 0.08,
                green: 0.10,
                blue: 0.18
            ),
            for: .navigationBar
        )
        .toolbarBackground(
            .visible,
            for: .navigationBar
        )
        .toolbarColorScheme(
            .dark,
            for: .navigationBar
        )
    }

    // MARK: - Background

    private var backgroundGradient: some View {
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
    }

    // MARK: - Founder Header

    private var founderHeader: some View {
        VStack(spacing: 12) {
            Image(
                systemName:
                    "person.crop.circle.fill"
            )
            .font(
                .system(size: 78)
            )
            .foregroundColor(.green)

            Text(
                gameViewModel
                    .playerProfile
                    .name
            )
            .font(
                .system(
                    size: 30,
                    weight: .bold
                )
            )
            .foregroundColor(.white)
            .multilineTextAlignment(
                .center
            )

            Text("Founder")
                .font(.headline)
                .foregroundColor(
                    .white.opacity(0.65)
                )

            VStack(spacing: 4) {
                Text("Founder Wealth")
                    .font(.caption)
                    .foregroundColor(
                        .white.opacity(0.55)
                    )

                Text(
                    formatCurrency(
                        profile.founderWealth
                    )
                )
                .font(
                    .system(
                        size: 28,
                        weight: .bold
                    )
                )
                .foregroundColor(.green)
            }
            .padding(.top, 4)
        }
        .frame(
            maxWidth: .infinity
        )
        .padding()
        .background(
            RoundedRectangle(
                cornerRadius: 20
            )
            .fill(
                Color.white.opacity(0.10)
            )
        )
        .overlay(
            RoundedRectangle(
                cornerRadius: 20
            )
            .stroke(
                Color.green.opacity(0.35),
                lineWidth: 1
            )
        )
    }

    // MARK: - Current Startup

    private var currentStartupCard: some View {
        VStack(
            alignment: .leading,
            spacing: 12
        ) {
            sectionTitle(
                title: "Current Startup",
                icon: "building.2.fill"
            )

            if gameViewModel
                .hasActiveStartup {

                HStack(spacing: 14) {
                    Image(
                        systemName:
                            gameViewModel
                                .company
                                .industry
                                .iconName
                    )
                    .font(.title2)
                    .foregroundColor(.green)
                    .frame(
                        width: 48,
                        height: 48
                    )
                    .background(
                        Circle()
                            .fill(
                                Color.green
                                    .opacity(0.15)
                            )
                    )

                    VStack(
                        alignment: .leading,
                        spacing: 4
                    ) {
                        Text(
                            gameViewModel
                                .company
                                .name
                        )
                        .font(.headline)
                        .foregroundColor(.white)

                        Text(
                            """
                            \(gameViewModel.company.industry.rawValue) • Month \(gameViewModel.company.month)
                            """
                        )
                        .font(.caption)
                        .foregroundColor(
                            .white.opacity(0.6)
                        )
                    }

                    Spacer()

                    VStack(
                        alignment: .trailing,
                        spacing: 4
                    ) {
                        Text("Market Value")
                            .font(.caption2)
                            .foregroundColor(
                                .white.opacity(0.5)
                            )

                        Text(
                            formatCurrency(
                                gameViewModel
                                    .company
                                    .marketValue
                            )
                        )
                        .font(
                            .subheadline.bold()
                        )
                        .foregroundColor(.green)
                    }
                }

            } else {
                HStack(spacing: 12) {
                    Image(
                        systemName:
                            "building.2.crop.circle"
                    )
                    .font(.title2)
                    .foregroundColor(
                        .white.opacity(0.45)
                    )

                    Text(
                        "No active startup"
                    )
                    .font(.subheadline)
                    .foregroundColor(
                        .white.opacity(0.65)
                    )

                    Spacer()
                }
            }
        }
        .founderCard()
    }

    // MARK: - Financial Summary

    private var financialSummarySection:
        some View {

        VStack(
            alignment: .leading,
            spacing: 12
        ) {
            sectionTitle(
                title: "Financial Summary",
                icon: "banknote.fill"
            )

            LazyVGrid(
                columns: statisticColumns,
                spacing: 12
            ) {
                FounderStatisticCard(
                    title: "Founder Wealth",
                    value:
                        formatCurrency(
                            profile
                                .founderWealth
                        ),
                    icon:
                        "dollarsign.circle.fill",
                    color: .green
                )

                FounderStatisticCard(
                    title: "Total Invested",
                    value:
                        formatCurrency(
                            profile
                                .totalMoneyInvested
                        ),
                    icon:
                        "arrow.up.circle.fill",
                    color: .orange
                )

                FounderStatisticCard(
                    title: "Sales Earnings",
                    value:
                        formatCurrency(
                            profile
                                .totalMoneyEarnedFromSales
                        ),
                    icon: "banknote.fill",
                    color: .green
                )

                FounderStatisticCard(
                    title: "Net Return",
                    value:
                        formatSignedCurrency(
                            netInvestmentReturn
                        ),
                    icon:
                        netInvestmentReturn >= 0
                        ? "chart.line.uptrend.xyaxis"
                        : "chart.line.downtrend.xyaxis",
                    color:
                        netInvestmentReturn >= 0
                        ? .green
                        : .red
                )
            }
        }
    }

    // MARK: - Business Journey

    private var businessJourneyChart:
        some View {

        VStack(
            alignment: .leading,
            spacing: 14
        ) {
            sectionTitle(
                title: "Business Journey",
                icon: "chart.bar.fill"
            )

            Text(
                """
                A summary of the startups you created and how they ended.
                """
            )
            .font(.caption)
            .foregroundColor(
                .white.opacity(0.55)
            )

            if hasBusinessJourneyData {
                Chart(
                    businessJourneyData
                ) { item in
                    BarMark(
                        x: .value(
                            "Category",
                            item.title
                        ),
                        y: .value(
                            "Startups",
                            item.value
                        )
                    )
                    .foregroundStyle(
                        item.color
                    )
                    .cornerRadius(6)
                    .annotation(
                        position: .top
                    ) {
                        Text(
                            "\(Int(item.value))"
                        )
                        .font(.caption.bold())
                        .foregroundColor(.white)
                    }
                }
                .chartXAxis {
                    AxisMarks { _ in
                        AxisValueLabel()
                            .foregroundStyle(
                                Color.white
                                    .opacity(0.65)
                            )
                    }
                }
                .chartYAxis {
                    AxisMarks(
                        position: .leading
                    ) { value in
                        AxisGridLine()
                            .foregroundStyle(
                                Color.white
                                    .opacity(0.08)
                            )

                        AxisTick()
                            .foregroundStyle(
                                Color.white
                                    .opacity(0.25)
                            )

                        AxisValueLabel {
                            if let number =
                                value.as(
                                    Int.self
                                ) {

                                Text(
                                    "\(number)"
                                )
                                .foregroundColor(
                                    .white.opacity(
                                        0.55
                                    )
                                )
                            }
                        }
                    }
                }
                .frame(height: 200)

                HStack(spacing: 14) {
                    chartLegend(
                        title: "Created",
                        color: .blue
                    )

                    chartLegend(
                        title: "Sold",
                        color: .green
                    )

                    chartLegend(
                        title: "Unicorns",
                        color: .purple
                    )

                    chartLegend(
                        title: "Bankrupt",
                        color: .red
                    )
                }
                .frame(
                    maxWidth: .infinity,
                    alignment: .center
                )

            } else {
                emptyChart(
                    icon: "building.2.fill",
                    message:
                        "Create your first startup to begin your business journey."
                )
            }
        }
        .founderCard()
    }

    // MARK: - Team Management

    private var teamManagementChart:
        some View {

        VStack(
            alignment: .leading,
            spacing: 14
        ) {
            sectionTitle(
                title: "Team Management",
                icon: "person.3.fill"
            )

            Text(
                """
                Your hiring and firing decisions across all startups.
                """
            )
            .font(.caption)
            .foregroundColor(
                .white.opacity(0.55)
            )

            if hasTeamData {
                Chart(
                    teamManagementData
                ) { item in
                    BarMark(
                        x: .value(
                            "Category",
                            item.title
                        ),
                        y: .value(
                            "Employees",
                            item.value
                        )
                    )
                    .foregroundStyle(
                        item.color
                    )
                    .cornerRadius(6)
                    .annotation(
                        position: .top
                    ) {
                        Text(
                            "\(Int(item.value))"
                        )
                        .font(.caption.bold())
                        .foregroundColor(.white)
                    }
                }
                .chartXAxis {
                    AxisMarks { _ in
                        AxisValueLabel()
                            .foregroundStyle(
                                Color.white.opacity(0.65)
                            )
                    }
                }
                .chartYAxis {
                    AxisMarks(
                        position: .leading
                    ) { value in
                        AxisGridLine()
                            .foregroundStyle(
                                Color.white.opacity(0.08)
                            )

                        AxisTick()

                        AxisValueLabel {
                            if let number =
                                value.as(
                                    Int.self
                                ) {

                                Text(
                                    "\(number)"
                                )
                                .foregroundColor(
                                    .white.opacity(0.55)
                                )
                            }
                        }
                    }
                }
                .frame(height: 190)

            } else {
                emptyChart(
                    icon: "person.3.fill",
                    message:
                        "Hire your first employee to begin building your team."
                )
            }
        }
        .founderCard()
    }

    // MARK: - Investment Return

    private var investmentReturnChart:
        some View {

        VStack(
            alignment: .leading,
            spacing: 14
        ) {
            sectionTitle(
                title: "Investment Return",
                icon:
                    "dollarsign.arrow.circlepath"
            )

            Text(
                """
                Compare how much money you've invested with how much you've earned from startup sales.
                """
            )
            .font(.caption)
            .foregroundColor(
                .white.opacity(0.55)
            )

            if hasMoneyData {

                Chart(
                    moneyData
                ) { item in
                    BarMark(
                        x: .value(
                            "Money",
                            item.title
                        ),
                        y: .value(
                            "Amount",
                            item.value
                        )
                    )
                    .foregroundStyle(
                        item.color
                    )
                    .cornerRadius(6)
                    .annotation(
                        position: .top,
                        spacing: 6
                    ) {
                        VStack(spacing: 2) {
                            Text(item.title)
                                .font(.caption2)
                                .foregroundColor(
                                    .white.opacity(0.65)
                                )

                            Text(
                                formatCurrency(
                                    item.value
                                )
                            )
                            .font(.caption.bold())
                            .foregroundColor(.white)
                        }
                    }
                }
                .chartXAxis {
                    AxisMarks { _ in
                        AxisValueLabel()
                            .foregroundStyle(
                                Color.white.opacity(0.65)
                            )
                    }
                }
                .chartYAxis {
                    AxisMarks(
                        position: .leading
                    ) { value in

                        AxisGridLine()
                            .foregroundStyle(
                                Color.white.opacity(0.08)
                            )

                        AxisValueLabel {
                            if let amount =
                                value.as(Double.self) {

                                Text(
                                    formatCurrency(
                                        amount
                                    )
                                )
                                .foregroundColor(
                                    .white.opacity(0.55)
                                )
                            }
                        }
                    }
                }
                .chartYScale(
                    domain: 0...investmentChartMaximum
                )
                .frame(height: 215)

                HStack {
                    investmentValueSummary(
                        title: "Total Invested",
                        value:
                            profile.totalMoneyInvested,
                        color: .orange
                    )

                    Spacer()

                    investmentValueSummary(
                        title: "Total Earned",
                        value:
                            profile
                                .totalMoneyEarnedFromSales,
                        color: .green
                    )
                }
                .padding(.horizontal, 6)

            } else {
                emptyChart(
                    icon:
                        "dollarsign.circle.fill",
                    message:
                        "Investment history will appear here after you begin investing and selling startups."
                )
            }
        }
        .founderCard()
    }

    // MARK: - Helpers
    
    private var investmentChartMaximum: Double {
        let largestValue = max(
            profile.totalMoneyInvested,
            profile.totalMoneyEarnedFromSales
        )

        if largestValue <= 0 {
            return 1
        }

        return largestValue * 1.25
    }

    private func investmentValueSummary(
        title: String,
        value: Double,
        color: Color
    ) -> some View {

        HStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(
                    width: 9,
                    height: 9
                )

            VStack(
                alignment: .leading,
                spacing: 2
            ) {
                Text(title)
                    .font(.caption2)
                    .foregroundColor(
                        .white.opacity(0.55)
                    )

                Text(
                    formatCurrency(value)
                )
                .font(.caption.bold())
                .foregroundColor(.white)
            }
        }
    }

    private var profile: PlayerProfile {
        gameViewModel.playerProfile
    }

    private var netInvestmentReturn: Double {
        profile.totalMoneyEarnedFromSales -
        profile.totalMoneyInvested
    }

    private var hasBusinessJourneyData: Bool {
        profile.totalStartupsCreated > 0
    }

    private var hasTeamData: Bool {
        profile.totalEmployeesHired > 0 ||
        profile.totalEmployeesFired > 0
    }

    private var hasMoneyData: Bool {
        profile.totalMoneyInvested > 0 ||
        profile.totalMoneyEarnedFromSales > 0
    }

    private var businessJourneyData:
        [FounderChartItem] {

        [
            FounderChartItem(
                title: "Created",
                value:
                    Double(
                        profile.totalStartupsCreated
                    ),
                color: .blue
            ),
            FounderChartItem(
                title: "Sold",
                value:
                    Double(
                        profile.startupsSold
                    ),
                color: .green
            ),
            FounderChartItem(
                title: "Unicorns",
                value:
                    Double(
                        profile.unicornsCreated
                    ),
                color: .purple
            ),
            FounderChartItem(
                title: "Bankrupt",
                value:
                    Double(
                        profile.startupsBankrupt
                    ),
                color: .red
            )
        ]
    }

    private var teamManagementData:
        [FounderChartItem] {

        [
            FounderChartItem(
                title: "Hired",
                value:
                    Double(
                        profile.totalEmployeesHired
                    ),
                color: .green
            ),
            FounderChartItem(
                title: "Fired",
                value:
                    Double(
                        profile.totalEmployeesFired
                    ),
                color: .red
            )
        ]
    }

    private var moneyData:
        [FounderChartItem] {

        [
            FounderChartItem(
                title: "Invested",
                value:
                    profile.totalMoneyInvested,
                color: .orange
            ),
            FounderChartItem(
                title: "Earned",
                value:
                    profile.totalMoneyEarnedFromSales,
                color: .green
            )
        ]
    }

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

    private func chartLegend(
        title: String,
        color: Color
    ) -> some View {

        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)

            Text(title)
                .font(.caption2)
                .foregroundColor(
                    .white.opacity(0.7)
                )
        }
    }

    private func emptyChart(
        icon: String,
        message: String
    ) -> some View {

        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(
                    .green.opacity(0.7)
                )

            Text(message)
                .font(.caption)
                .foregroundColor(
                    .white.opacity(0.55)
                )
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 150)
        .background(
            RoundedRectangle(
                cornerRadius: 14
            )
            .fill(
                Color.black.opacity(0.16)
            )
        )
    }

    private func formatCurrency(
        _ amount: Double
    ) -> String {

        let value = abs(amount)

        if value >= 1_000_000_000 {
            return String(
                format: "$%.1fB",
                value / 1_000_000_000
            )
        }

        if value >= 1_000_000 {
            return String(
                format: "$%.1fM",
                value / 1_000_000
            )
        }

        if value >= 1_000 {
            return String(
                format: "$%.0fK",
                value / 1_000
            )
        }

        return "$\(Int(value))"
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

// MARK: - Statistic Card

struct FounderStatisticCard: View {

    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {

        VStack(
            alignment: .leading,
            spacing: 10
        ) {

            Image(systemName: icon)
                .foregroundColor(color)

            Text(value)
                .font(.title3.bold())
                .foregroundColor(.white)

            Text(title)
                .font(.caption)
                .foregroundColor(
                    .white.opacity(0.6)
                )
        }
        .frame(
            maxWidth: .infinity,
            minHeight: 90,
            alignment: .leading
        )
        .padding()
        .background(
            RoundedRectangle(
                cornerRadius: 16
            )
            .fill(
                Color.white.opacity(0.10)
            )
        )
    }
}

private struct FounderChartItem:
    Identifiable {

    let id = UUID()
    let title: String
    let value: Double
    let color: Color
}

private extension View {

    func founderCard() -> some View {

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

struct FounderView_Previews:
    PreviewProvider {

    static var previews: some View {

        NavigationStack {
            FounderView()
                .environmentObject(
                    GameViewModel()
                )
        }
    }
}
