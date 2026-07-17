//
//  GameOverView.swift
//  StartUpSimulation
//
//  Created by Talya Benatar on 15/07/2026.
//

import SwiftUI

struct GameOverView: View {
    @EnvironmentObject private var gameViewModel: GameViewModel

    let onReturnToMainMenu: () -> Void

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

            VStack(spacing: 24) {
                Spacer()

                Image(systemName: outcomeIcon)
                    .font(.system(size: 78))
                    .foregroundColor(outcomeColor)

                Text(outcomeTitle)
                    .font(
                        .system(
                            size: 34,
                            weight: .bold
                        )
                    )
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                Text(outcomeMessage)
                    .font(.headline)
                    .foregroundColor(
                        .white.opacity(0.7)
                    )
                    .multilineTextAlignment(.center)

                VStack(spacing: 10) {
                    resultRow(
                        title: "Final Month",
                        value:
                            "\(gameViewModel.company.month)"
                    )

                    resultRow(
                        title: "Final Cash",
                        value: formatCurrency(
                            gameViewModel.company.cash
                        )
                    )

                    resultRow(
                        title: "Market Value",
                        value: formatCurrency(
                            gameViewModel.company
                                .marketValue
                        )
                    )

                    resultRow(
                        title: "Employees",
                        value:
                            "\(gameViewModel.company.employeeCount)"
                    )
                }
                .padding()
                .background(
                    RoundedRectangle(
                        cornerRadius: 18
                    )
                    .fill(
                        Color.white.opacity(0.09)
                    )
                )

                Spacer()

                Button {
                    returnToMainMenu()
                } label: {
                    HStack {
                        Image(
                            systemName: "house.fill"
                        )

                        Text("Return to Main Menu")
                            .font(.headline)
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(
                            cornerRadius: 16
                        )
                        .fill(outcomeColor)
                    )
                }
            }
            .padding(24)
        }
        .interactiveDismissDisabled()
    }

    private var outcomeTitle: String {
        switch gameViewModel.gameOutcome {
        case .active:
            return "Game Over"

        case .bankrupt:
            return "Startup Bankrupt"

        case .unicorn:
            return "Unicorn Achieved"

        case .sold:
            return "Startup Acquired!"
        }
    }

    private var outcomeMessage: String {
        switch gameViewModel.gameOutcome {
        case .active:
            return ""

        case .bankrupt:
            return """
            Your company crossed the debt limit. The runway has officially become a crater.
            """

        case .unicorn:
            return """
            Your startup reached a valuation of one billion dollars. Investors may now use the word “disruptive” without irony.
            """

        case .sold:
            return """
            Your startup was acquired for \(formatCurrency(gameViewModel.lastStartupSaleValue)). The money has been added to your founder wealth.
            """
        }
    }

    private var outcomeIcon: String {
        switch gameViewModel.gameOutcome {
        case .active:
            return "flag.checkered"

        case .bankrupt:
            return """
            creditcard.trianglebadge.exclamationmark
            """

        case .unicorn:
            return "sparkles"

        case .sold:
            return "building.2.crop.circle.fill"
        }
    }

    private var outcomeColor: Color {
        switch gameViewModel.gameOutcome {
        case .active:
            return .green

        case .bankrupt:
            return .red

        case .unicorn:
            return .green

        case .sold:
            return .green
        }
    }

    private func returnToMainMenu() {
        gameViewModel.company = .empty
        gameViewModel.gameOutcome = .active

        onReturnToMainMenu()
    }

    private func resultRow(
        title: String,
        value: String
    ) -> some View {
        HStack {
            Text(title)
                .foregroundColor(
                    .white.opacity(0.65)
                )

            Spacer()

            Text(value)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }

    private func formatCurrency(
        _ amount: Double
    ) -> String {
        let sign = amount < 0 ? "-" : ""
        let absoluteAmount = abs(amount)

        if absoluteAmount >= 1_000_000_000 {
            return sign + String(
                format: "$%.1fB",
                absoluteAmount /
                    1_000_000_000
            )
        }

        if absoluteAmount >= 1_000_000 {
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
}

struct GameOverView_Previews:
    PreviewProvider {

    static var previews: some View {
        let game = GameViewModel(
            company: Company.newCompany(
                name: "Mowers",
                industry:
                    .artificialIntelligence
            )
        )

        game.lastStartupSaleValue = game.company.marketValue
        game.gameOutcome = .sold

        return GameOverView(
            onReturnToMainMenu: {}
        )
        .environmentObject(game)
    }
}
