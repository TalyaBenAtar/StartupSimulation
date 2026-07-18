//
//  HowToPlayView.swift
//  StartUpSimulation
//
//  Created by Talya Benatar on 18/07/2026.
//

import SwiftUI

struct HowToPlayView: View {

    private let managementColumns = [
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
                    Group {
                        header

                        mainGoalSection

                        startupCreationSection

                        monthlyGameLoopSection

                        earningMoneySection
                    }

                    Group {
                        losingMoneySection

                        companyMetricsSection

                        managementPagesSection

                        marketValueSection

                        founderMoneySection
                    }

                    Group {
                        sellingSection

                        winningAndLosingSection

                        strategySection

                        finalReminder
                    }
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
                    32
                )
            }
        }
        .navigationTitle(
            "How to Play"
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

    // MARK: - Header

    private var header: some View {
        VStack(spacing: 12) {
            Image(
                systemName:
                    "questionmark.circle.fill"
            )
            .font(
                .system(size: 70)
            )
            .foregroundColor(.green)

            Text("Build a Startup")
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

            Text(
                """
                Make calculated decisions, manage your money and grow your company before it runs out of cash.
                """
            )
            .font(.subheadline)
            .foregroundColor(
                .white.opacity(0.68)
            )
            .multilineTextAlignment(
                .center
            )
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

    // MARK: - Goal

    private var mainGoalSection: some View {
        instructionCard(
            title: "Your Goal",
            icon: "target",
            accentColor: .green
        ) {
            VStack(
                alignment: .leading,
                spacing: 12
            ) {
                Text(
                    """
                    Your goal is to grow your startup until it becomes a Unicorn.
                    """
                )
                .font(.headline)
                .foregroundColor(.white)

                instructionRow(
                    icon:
                        "chart.line.uptrend.xyaxis",
                    title: "Grow the company",
                    description:
                        "Increase revenue, product quality, brand awareness and market value."
                )

                instructionRow(
                    icon:
                        "dollarsign.circle.fill",
                    title: "Protect your cash",
                    description:
                        "Your startup must be able to pay its expenses every month."
                )

                instructionRow(
                    icon: "sparkles",
                    title: "Reach Unicorn status",
                    description:
                        "A Unicorn is a startup with a market value of at least $1 billion."
                )
            }
        }
    }

    // MARK: - Startup Creation

    private var startupCreationSection:
        some View {

        instructionCard(
            title: "Starting a New Game",
            icon: "plus.circle.fill",
            accentColor: .blue
        ) {
            VStack(
                alignment: .leading,
                spacing: 12
            ) {
                instructionRow(
                    icon: "person.fill",
                    title: "Create your founder",
                    description:
                        "Your founder profile and career statistics continue between startups."
                )

                instructionRow(
                    icon: "building.2.fill",
                    title: "Create your startup",
                    description:
                        "Choose a company name and industry before entering the dashboard."
                )

                instructionRow(
                    icon:
                        "dollarsign.circle.fill",
                    title: "Starting cash",
                    description:
                        "Every new startup begins with $150,000 in company cash."
                )

                instructionRow(
                    icon: "1.circle.fill",
                    title: "One active startup",
                    description:
                        "You can manage only one startup at a time. You must sell the current company before creating another."
                )
            }
        }
    }

    // MARK: - Monthly Game Loop

    private var monthlyGameLoopSection:
        some View {

        instructionCard(
            title: "How Each Month Works",
            icon:
                "calendar.badge.clock",
            accentColor: .green
        ) {
            VStack(
                alignment: .leading,
                spacing: 14
            ) {
                numberedStep(
                    number: 1,
                    title: "Review the dashboard",
                    description:
                        "Check your cash, revenue, expenses, product quality, morale and market value."
                )

                numberedStep(
                    number: 2,
                    title: "Make decisions",
                    description:
                        "Hire employees, improve the product, run marketing campaigns or review your finances."
                )

                numberedStep(
                    number: 3,
                    title: "Check affordability",
                    description:
                        "Make sure you will still have enough cash after your purchases and monthly expenses."
                )

                numberedStep(
                    number: 4,
                    title: "Press End Month",
                    description:
                        "Revenue is received, recurring expenses are paid and the company's statistics are updated."
                )

                numberedStep(
                    number: 5,
                    title: "Read the monthly summary",
                    description:
                        "The summary explains exactly where money came from, where it went and how the company changed."
                )
            }
        }
    }

    // MARK: - Earning Money

    private var earningMoneySection:
        some View {

        instructionCard(
            title: "How the Startup Earns Money",
            icon: "arrow.up.circle.fill",
            accentColor: .green
        ) {
            VStack(
                alignment: .leading,
                spacing: 12
            ) {
                Text(
                    """
                    Startup revenue is received when you complete a month. Strong company metrics help the business grow and generate more revenue.
                    """
                )
                .font(.subheadline)
                .foregroundColor(
                    .white.opacity(0.72)
                )

                moneyFactorRow(
                    title: "Product Quality",
                    description:
                        "A stronger product gives customers more reason to use and pay for it.",
                    positive: true
                )

                moneyFactorRow(
                    title: "Brand Awareness",
                    description:
                        "Marketing helps more potential customers discover the company.",
                    positive: true
                )

                moneyFactorRow(
                    title: "Employees",
                    description:
                        "A larger and stronger team can support company growth, but employees also increase expenses.",
                    positive: true
                )

                moneyFactorRow(
                    title: "Good Morale",
                    description:
                        "A healthy team performs better than an unhappy one.",
                    positive: true
                )

                tipBox(
                    text:
                        "Revenue does not appear immediately when you buy an upgrade. Most results are calculated when you end the month."
                )
            }
        }
    }

    // MARK: - Losing Money

    private var losingMoneySection:
        some View {

        instructionCard(
            title: "How the Startup Spends Money",
            icon: "arrow.down.circle.fill",
            accentColor: .red
        ) {
            VStack(
                alignment: .leading,
                spacing: 12
            ) {
                Text(
                    """
                    There are two types of spending: one-time spending and recurring monthly expenses.
                    """
                )
                .font(.subheadline)
                .foregroundColor(
                    .white.opacity(0.72)
                )

                costTypeBox(
                    title: "One-Time Spending",
                    icon: "cart.fill",
                    examples:
                        "Product development, hiring costs, severance costs and one-time marketing campaigns.",
                    color: .orange
                )

                costTypeBox(
                    title: "Recurring Expenses",
                    icon:
                        "repeat.circle.fill",
                    examples:
                        "Operating costs, employee salaries and active marketing subscriptions.",
                    color: .red
                )

                moneyFactorRow(
                    title: "Employee Salaries",
                    description:
                        "Every employee adds a salary that must be paid every month.",
                    positive: false
                )

                moneyFactorRow(
                    title: "Operating Costs",
                    description:
                        "The startup has basic recurring expenses even before hiring a large team.",
                    positive: false
                )

                moneyFactorRow(
                    title: "Marketing Subscriptions",
                    description:
                        "Subscription campaigns continue charging the company every month until they are no longer active.",
                    positive: false
                )

                warningBox(
                    text:
                        "A purchase may be affordable now but dangerous later. Always consider the next month's salaries and recurring expenses."
                )
            }
        }
    }

    // MARK: - Company Metrics

    private var companyMetricsSection:
        some View {

        instructionCard(
            title: "Understanding Company Metrics",
            icon: "gauge.with.dots.needle.67percent",
            accentColor: .yellow
        ) {
            VStack(spacing: 12) {
                metricExplanation(
                    title: "Cash",
                    icon:
                        "dollarsign.circle.fill",
                    color: .green,
                    description:
                        "Money currently owned by the startup. Company purchases and expenses are paid from this balance."
                )

                metricExplanation(
                    title: "Revenue",
                    icon:
                        "arrow.up.circle.fill",
                    color: .green,
                    description:
                        "Money generated by the company during a month."
                )

                metricExplanation(
                    title: "Expenses",
                    icon:
                        "arrow.down.circle.fill",
                    color: .red,
                    description:
                        "The company's recurring monthly costs."
                )

                metricExplanation(
                    title: "Product Quality",
                    icon: "star.fill",
                    color: .yellow,
                    description:
                        "Represents how strong and competitive the startup's product is."
                )

                metricExplanation(
                    title: "Employee Morale",
                    icon:
                        "face.smiling.fill",
                    color: .orange,
                    description:
                        "Represents how satisfied and motivated the team is."
                )

                metricExplanation(
                    title: "Brand Awareness",
                    icon: "megaphone.fill",
                    color: .orange,
                    description:
                        "Represents how familiar customers are with the startup."
                )

                metricExplanation(
                    title: "Market Value",
                    icon:
                        "chart.line.uptrend.xyaxis",
                    color: .blue,
                    description:
                        "The estimated value of the entire company. This determines company stage, sale value and progress toward becoming a Unicorn."
                )
            }
        }
    }

    // MARK: - Management Pages

    private var managementPagesSection:
        some View {

        instructionCard(
            title: "Management Pages",
            icon: "square.grid.2x2.fill",
            accentColor: .purple
        ) {
            LazyVGrid(
                columns: managementColumns,
                spacing: 12
            ) {
                managementPageCard(
                    title: "Employees",
                    icon: "person.3.fill",
                    color: .purple,
                    description:
                        "Hire employees, review salaries and fire team members."
                )

                managementPageCard(
                    title: "Product",
                    icon: "shippingbox.fill",
                    color: .yellow,
                    description:
                        "Spend money on development to improve product quality."
                )

                managementPageCard(
                    title: "Marketing",
                    icon: "megaphone.fill",
                    color: .orange,
                    description:
                        "Run campaigns and subscriptions to improve brand awareness."
                )

                managementPageCard(
                    title: "Finance",
                    icon: "banknote.fill",
                    color: .green,
                    description:
                        "Review revenue, expenses, spending and expected monthly results."
                )
            }
        }
    }

    // MARK: - Market Value

    private var marketValueSection:
        some View {

        instructionCard(
            title: "Market Value and Company Stages",
            icon:
                "chart.line.uptrend.xyaxis",
            accentColor: .blue
        ) {
            VStack(
                alignment: .leading,
                spacing: 12
            ) {
                Text(
                    """
                    Market value represents the estimated worth of your startup. It changes according to the overall condition and performance of the company.
                    """
                )
                .font(.subheadline)
                .foregroundColor(
                    .white.opacity(0.72)
                )

                instructionRow(
                    icon: "arrow.up",
                    title: "Market value can rise",
                    description:
                        "Strong revenue, product quality, marketing and company performance can increase it."
                )

                instructionRow(
                    icon: "arrow.down",
                    title: "Market value can fall",
                    description:
                        "Weak performance or poor company metrics can reduce it."
                )

                instructionRow(
                    icon: "flag.fill",
                    title: "Stages can change",
                    description:
                        "Your startup advances when its value grows, but it can also fall back to an earlier stage."
                )

                instructionRow(
                    icon:
                        "chart.xyaxis.line",
                    title: "Follow the chart",
                    description:
                        "The dashboard records market value over time so you can see whether your decisions are working."
                )
            }
        }
    }

    // MARK: - Founder Money

    private var founderMoneySection:
        some View {

        instructionCard(
            title: "Founder Wealth vs. Startup Cash",
            icon: "person.crop.circle.fill",
            accentColor: .green
        ) {
            VStack(
                alignment: .leading,
                spacing: 12
            ) {
                comparisonBox(
                    title: "Startup Cash",
                    icon: "building.2.fill",
                    color: .blue,
                    description:
                        "Belongs to the company and is used for salaries, marketing, product development and operating costs."
                )

                comparisonBox(
                    title: "Founder Wealth",
                    icon:
                        "person.crop.circle.fill",
                    color: .green,
                    description:
                        "Belongs to your founder personally and continues between different startups."
                )

                instructionRow(
                    icon:
                        "arrow.right.arrow.left",
                    title: "Founder investment",
                    description:
                        "You may invest personal founder wealth into the startup. This increases company cash but reduces founder wealth."
                )

                instructionRow(
                    icon: "banknote.fill",
                    title: "Startup sale",
                    description:
                        "When you sell a startup, its sale value is transferred to founder wealth."
                )

                warningBox(
                    text:
                        "Founder wealth and startup cash are separate balances. A wealthy founder does not automatically prevent an active startup from going bankrupt."
                )
            }
        }
    }

    // MARK: - Selling

    private var sellingSection:
        some View {

        instructionCard(
            title: "Selling Your Startup",
            icon: "building.2.crop.circle",
            accentColor: .orange
        ) {
            VStack(
                alignment: .leading,
                spacing: 12
            ) {
                instructionRow(
                    icon: "tag.fill",
                    title: "Sale price",
                    description:
                        "The startup is sold for its current market value."
                )

                instructionRow(
                    icon:
                        "dollarsign.circle.fill",
                    title: "Founder receives the money",
                    description:
                        "The sale amount is added to founder wealth."
                )

                instructionRow(
                    icon: "stop.circle.fill",
                    title: "The current game ends",
                    description:
                        "After selling, the startup is no longer active."
                )

                instructionRow(
                    icon: "plus.circle.fill",
                    title: "Start again",
                    description:
                        "You may then create a new startup while keeping your founder profile, wealth and career statistics."
                )

                warningBox(
                    text:
                        "Selling is permanent. The game asks for confirmation before completing the sale."
                )
            }
        }
    }

    // MARK: - Win and Lose

    private var winningAndLosingSection:
        some View {

        instructionCard(
            title: "Winning and Losing",
            icon: "flag.checkered",
            accentColor: .green
        ) {
            VStack(spacing: 12) {
                resultBox(
                    title: "You Win",
                    icon: "sparkles",
                    color: .green,
                    description:
                        "Reach a market value of $1 billion and turn the company into a Unicorn."
                )

                resultBox(
                    title: "You Lose",
                    icon:
                        "exclamationmark.triangle.fill",
                    color: .red,
                    description:
                        "The startup becomes bankrupt when it can no longer survive financially."
                )

                Text(
                    """
                    Winning or losing ends the active startup, but your founder profile and career progress remain saved.
                    """
                )
                .font(.caption)
                .foregroundColor(
                    .white.opacity(0.6)
                )
                .multilineTextAlignment(
                    .center
                )
                .padding(.top, 4)
            }
        }
    }

    // MARK: - Strategy

    private var strategySection:
        some View {

        instructionCard(
            title: "Playing Strategically",
            icon: "lightbulb.fill",
            accentColor: .yellow
        ) {
            VStack(
                alignment: .leading,
                spacing: 12
            ) {
                strategyRow(
                    number: 1,
                    text:
                        "Check the Finance page before ending every month."
                )

                strategyRow(
                    number: 2,
                    text:
                        "Do not spend all available cash just because an upgrade is affordable."
                )

                strategyRow(
                    number: 3,
                    text:
                        "Remember that salaries and subscriptions repeat every month."
                )

                strategyRow(
                    number: 4,
                    text:
                        "Balance product development and marketing. A good product still needs customers, and marketing cannot save a weak product forever."
                )

                strategyRow(
                    number: 5,
                    text:
                        "Hire only when the benefit is worth the additional salary."
                )

                strategyRow(
                    number: 6,
                    text:
                        "Watch employee morale because company growth is not only about money."
                )

                strategyRow(
                    number: 7,
                    text:
                        "Use the monthly summary to understand which decisions helped or harmed the company."
                )

                strategyRow(
                    number: 8,
                    text:
                        "Follow the market value chart instead of judging a decision based on only one month."
                )
            }
        }
    }

    // MARK: - Final Reminder

    private var finalReminder: some View {
        VStack(spacing: 10) {
            Image(
                systemName:
                    "chart.line.uptrend.xyaxis"
            )
            .font(.title)
            .foregroundColor(.green)

            Text(
                "There is no single correct strategy."
            )
            .font(.headline)
            .foregroundColor(.white)

            Text(
                """
                Grow carefully, understand every expense and make sure the startup survives long enough to become valuable.
                """
            )
            .font(.subheadline)
            .foregroundColor(
                .white.opacity(0.65)
            )
            .multilineTextAlignment(
                .center
            )
        }
        .frame(
            maxWidth: .infinity
        )
        .padding()
        .background(
            RoundedRectangle(
                cornerRadius: 18
            )
            .fill(
                Color.green.opacity(0.12)
            )
        )
        .overlay(
            RoundedRectangle(
                cornerRadius: 18
            )
            .stroke(
                Color.green.opacity(0.35),
                lineWidth: 1
            )
        )
    }

    // MARK: - Reusable Card

    private func instructionCard<Content: View>(
        title: String,
        icon: String,
        accentColor: Color,
        @ViewBuilder content: () -> Content
    ) -> some View {

        VStack(
            alignment: .leading,
            spacing: 14
        ) {
            HStack(spacing: 9) {
                Image(systemName: icon)
                    .foregroundColor(
                        accentColor
                    )

                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
            }

            content()
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
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

    // MARK: - Instruction Row

    private func instructionRow(
        icon: String,
        title: String,
        description: String
    ) -> some View {

        HStack(
            alignment: .top,
            spacing: 12
        ) {
            Image(systemName: icon)
                .foregroundColor(.green)
                .frame(width: 22)

            VStack(
                alignment: .leading,
                spacing: 3
            ) {
                Text(title)
                    .font(
                        .subheadline.bold()
                    )
                    .foregroundColor(.white)

                Text(description)
                    .font(.caption)
                    .foregroundColor(
                        .white.opacity(0.62)
                    )
                    .fixedSize(
                        horizontal: false,
                        vertical: true
                    )
            }
        }
    }

    // MARK: - Numbered Step

    private func numberedStep(
        number: Int,
        title: String,
        description: String
    ) -> some View {

        HStack(
            alignment: .top,
            spacing: 12
        ) {
            Text("\(number)")
                .font(.caption.bold())
                .foregroundColor(.black)
                .frame(
                    width: 26,
                    height: 26
                )
                .background(
                    Circle()
                        .fill(Color.green)
                )

            VStack(
                alignment: .leading,
                spacing: 3
            ) {
                Text(title)
                    .font(
                        .subheadline.bold()
                    )
                    .foregroundColor(.white)

                Text(description)
                    .font(.caption)
                    .foregroundColor(
                        .white.opacity(0.62)
                    )
                    .fixedSize(
                        horizontal: false,
                        vertical: true
                    )
            }
        }
    }

    // MARK: - Money Factor

    private func moneyFactorRow(
        title: String,
        description: String,
        positive: Bool
    ) -> some View {

        HStack(
            alignment: .top,
            spacing: 12
        ) {
            Image(
                systemName:
                    positive
                    ? "plus.circle.fill"
                    : "minus.circle.fill"
            )
            .foregroundColor(
                positive ? .green : .red
            )
            .frame(width: 22)

            VStack(
                alignment: .leading,
                spacing: 3
            ) {
                Text(title)
                    .font(
                        .subheadline.bold()
                    )
                    .foregroundColor(.white)

                Text(description)
                    .font(.caption)
                    .foregroundColor(
                        .white.opacity(0.62)
                    )
                    .fixedSize(
                        horizontal: false,
                        vertical: true
                    )
            }
        }
    }

    // MARK: - Cost Type

    private func costTypeBox(
        title: String,
        icon: String,
        examples: String,
        color: Color
    ) -> some View {

        HStack(
            alignment: .top,
            spacing: 12
        ) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)
                .frame(width: 28)

            VStack(
                alignment: .leading,
                spacing: 4
            ) {
                Text(title)
                    .font(
                        .subheadline.bold()
                    )
                    .foregroundColor(.white)

                Text(examples)
                    .font(.caption)
                    .foregroundColor(
                        .white.opacity(0.62)
                    )
            }

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(
                cornerRadius: 14
            )
            .fill(
                color.opacity(0.10)
            )
        )
    }

    // MARK: - Metric

    private func metricExplanation(
        title: String,
        icon: String,
        color: Color,
        description: String
    ) -> some View {

        HStack(
            alignment: .top,
            spacing: 12
        ) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(
                    width: 32,
                    height: 32
                )
                .background(
                    Circle()
                        .fill(
                            color.opacity(0.12)
                        )
                )

            VStack(
                alignment: .leading,
                spacing: 3
            ) {
                Text(title)
                    .font(
                        .subheadline.bold()
                    )
                    .foregroundColor(.white)

                Text(description)
                    .font(.caption)
                    .foregroundColor(
                        .white.opacity(0.62)
                    )
                    .fixedSize(
                        horizontal: false,
                        vertical: true
                    )
            }

            Spacer()
        }
    }

    // MARK: - Management Page

    private func managementPageCard(
        title: String,
        icon: String,
        color: Color,
        description: String
    ) -> some View {

        VStack(
            alignment: .leading,
            spacing: 9
        ) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)

            Text(title)
                .font(
                    .subheadline.bold()
                )
                .foregroundColor(.white)

            Text(description)
                .font(.caption2)
                .foregroundColor(
                    .white.opacity(0.58)
                )
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )
        }
        .frame(
            maxWidth: .infinity,
            minHeight: 128,
            alignment: .topLeading
        )
        .padding()
        .background(
            RoundedRectangle(
                cornerRadius: 15
            )
            .fill(
                Color.white.opacity(0.08)
            )
        )
    }

    // MARK: - Comparison

    private func comparisonBox(
        title: String,
        icon: String,
        color: Color,
        description: String
    ) -> some View {

        HStack(
            alignment: .top,
            spacing: 12
        ) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title2)
                .frame(width: 34)

            VStack(
                alignment: .leading,
                spacing: 4
            ) {
                Text(title)
                    .font(
                        .subheadline.bold()
                    )
                    .foregroundColor(.white)

                Text(description)
                    .font(.caption)
                    .foregroundColor(
                        .white.opacity(0.62)
                    )
            }

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(
                cornerRadius: 14
            )
            .fill(
                color.opacity(0.10)
            )
        )
    }

    // MARK: - Result

    private func resultBox(
        title: String,
        icon: String,
        color: Color,
        description: String
    ) -> some View {

        HStack(
            alignment: .top,
            spacing: 12
        ) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title2)
                .frame(width: 34)

            VStack(
                alignment: .leading,
                spacing: 4
            ) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(color)

                Text(description)
                    .font(.caption)
                    .foregroundColor(
                        .white.opacity(0.68)
                    )
            }

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(
                cornerRadius: 14
            )
            .fill(
                color.opacity(0.10)
            )
        )
        .overlay(
            RoundedRectangle(
                cornerRadius: 14
            )
            .stroke(
                color.opacity(0.25),
                lineWidth: 1
            )
        )
    }

    // MARK: - Strategy Row

    private func strategyRow(
        number: Int,
        text: String
    ) -> some View {

        HStack(
            alignment: .top,
            spacing: 11
        ) {
            Text("\(number)")
                .font(.caption.bold())
                .foregroundColor(.black)
                .frame(
                    width: 24,
                    height: 24
                )
                .background(
                    Circle()
                        .fill(Color.yellow)
                )

            Text(text)
                .font(.subheadline)
                .foregroundColor(
                    .white.opacity(0.75)
                )
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )
        }
    }

    // MARK: - Tip and Warning

    private func tipBox(
        text: String
    ) -> some View {

        HStack(
            alignment: .top,
            spacing: 10
        ) {
            Image(
                systemName: "lightbulb.fill"
            )
            .foregroundColor(.yellow)

            Text(text)
                .font(.caption)
                .foregroundColor(
                    .white.opacity(0.7)
                )
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(
                cornerRadius: 13
            )
            .fill(
                Color.yellow.opacity(0.10)
            )
        )
    }

    private func warningBox(
        text: String
    ) -> some View {

        HStack(
            alignment: .top,
            spacing: 10
        ) {
            Image(
                systemName:
                    "exclamationmark.triangle.fill"
            )
            .foregroundColor(.orange)

            Text(text)
                .font(.caption)
                .foregroundColor(
                    .white.opacity(0.7)
                )
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(
                cornerRadius: 13
            )
            .fill(
                Color.orange.opacity(0.10)
            )
        )
    }
}

// MARK: - Preview

struct HowToPlayView_Previews:
    PreviewProvider {

    static var previews: some View {
        NavigationStack {
            HowToPlayView()
        }
    }
}
