//
//  DashboardView.swift
//  StartUpSimulation
//
//  Created by Talya Benatar on 15/07/2026.
//

import SwiftUI
import Charts

struct DashboardView: View {
    @EnvironmentObject private var gameViewModel: GameViewModel
    @State private var showEmployees = false
    @State private var monthResult: MonthResult?
    @State private var showMonthSummary = false

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
        .sheet(isPresented: $showMonthSummary) {
            if let monthResult {
                MonthSummaryView(result: monthResult)
            }
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
                    print("Product tapped")
                }

                DashboardActionButton(
                    title: "Marketing",
                    icon: "megaphone.fill",
                    color: .orange
                ) {
                    print("Marketing tapped")
                }

                DashboardActionButton(
                    title: "Finance",
                    icon: "banknote.fill",
                    color: .green
                ) {
                    print("Finance tapped")
                }
            }
        }
    }

    private var endMonthButton: some View {
        Button {
            monthResult = gameViewModel.advanceMonth()
            showMonthSummary = true
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
                    Color(red: 0.08, green: 0.10, blue: 0.18),
                    Color(red: 0.12, green: 0.20, blue: 0.32)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 22) {
                    Image(systemName: "calendar.circle.fill")
                        .font(.system(size: 54))
                        .foregroundColor(.green)

                    Text("Month \(result.completedMonth) Complete")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)

                    Text(summaryMessage)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.65))
                        .multilineTextAlignment(.center)

                    VStack(spacing: 12) {
                        resultRow(
                            title: "Revenue",
                            value: formatCurrency(result.newRevenue),
                            change: result.revenueChange,
                            icon: "arrow.up.circle.fill"
                        )

                        resultRow(
                            title: "Expenses",
                            value: formatCurrency(result.totalExpenses),
                            change: nil,
                            icon: "arrow.down.circle.fill"
                        )

                        resultRow(
                            title: "Profit",
                            value: formatSignedCurrency(result.monthlyProfit),
                            change: nil,
                            icon: result.monthlyProfit >= 0
                                ? "plus.circle.fill"
                                : "minus.circle.fill"
                        )

                        resultRow(
                            title: "Cash",
                            value: formatCurrency(result.newCash),
                            change: result.cashChange,
                            icon: "dollarsign.circle.fill"
                        )

                        resultRow(
                            title: "Market Value",
                            value: formatCurrency(result.newMarketValue),
                            change: result.marketValueChange,
                            icon: "chart.line.uptrend.xyaxis"
                        )

                        percentageRow(
                            title: "Product Quality",
                            value: result.newProductQuality,
                            change: result.productQualityChange,
                            icon: "star.fill"
                        )

                        percentageRow(
                            title: "Team Morale",
                            value: result.newMorale,
                            change: result.moraleChange,
                            icon: "face.smiling.fill"
                        )
                    }

                    Button {
                        dismiss()
                    } label: {
                        Text("Continue to Month \(result.completedMonth + 1)")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.green)
                            )
                    }
                }
                .padding(24)
            }
        }
    }

    private var summaryMessage: String {
        if result.monthlyProfit > 0 {
            return "The company finished the month with a profit. Investors are cautiously impressed."
        }

        if result.monthlyProfit == 0 {
            return "The company broke even. Not glamorous, but definitely alive."
        }

        return "The company lost money this month. The runway is getting shorter."
    }

    private func resultRow(
        title: String,
        value: String,
        change: Double?,
        icon: String
    ) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.green)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))

                Text(value)
                    .font(.headline)
                    .foregroundColor(.white)
            }

            Spacer()

            if let change {
                Text(formatSignedCurrency(change))
                    .font(.subheadline.bold())
                    .foregroundColor(
                        change >= 0 ? .green : .red
                    )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.09))
        )
    }

    private func percentageRow(
        title: String,
        value: Int,
        change: Int,
        icon: String
    ) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.green)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))

                Text("\(value)%")
                    .font(.headline)
                    .foregroundColor(.white)
            }

            Spacer()

            Text("\(change >= 0 ? "+" : "")\(change)%")
                .font(.subheadline.bold())
                .foregroundColor(
                    change >= 0 ? .green : .red
                )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.09))
        )
    }

    private func formatCurrency(_ amount: Double) -> String {
        let absoluteAmount = abs(amount)

        if absoluteAmount >= 1_000_000_000 {
            return String(
                format: "$%.1fB",
                amount / 1_000_000_000
            )
        }

        if absoluteAmount >= 1_000_000 {
            return String(
                format: "$%.1fM",
                amount / 1_000_000
            )
        }

        if absoluteAmount >= 1_000 {
            return String(
                format: "$%.0fK",
                amount / 1_000
            )
        }

        return "$\(Int(amount))"
    }

    private func formatSignedCurrency(
        _ amount: Double
    ) -> String {
        let sign = amount >= 0 ? "+" : "-"

        return sign + formatCurrency(abs(amount))
    }
}


struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DashboardView()
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
