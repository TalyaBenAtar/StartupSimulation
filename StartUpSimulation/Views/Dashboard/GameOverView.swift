//
//  GameOverView.swift
//  StartUpSimulation
//
//  Created by Talya Benatar on 15/07/2026.
//

import SwiftUI

struct GameOverView: View {
    @EnvironmentObject private var gameViewModel: GameViewModel

    @State private var animateCelebration = false

    let onReturnToMainMenu: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: backgroundColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            if gameViewModel.gameOutcome == .unicorn {
                confettiLayer
            }

            VStack(spacing: 24) {
                Spacer()

                outcomeImage

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
                        .white.opacity(0.75)
                    )
                    .multilineTextAlignment(.center)

                VStack(spacing: 10) {
                    resultRow(
                        title: "Startup",
                        value: gameViewModel.company.name
                    )

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
                        Color.white.opacity(0.10)
                    )
                )
                .overlay(
                    RoundedRectangle(
                        cornerRadius: 18
                    )
                    .stroke(
                        outcomeColor.opacity(0.35),
                        lineWidth: 1
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
                    .foregroundColor(.white)
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
        .onAppear {
            animateCelebration = true

            switch gameViewModel.gameOutcome {
            case .unicorn:
                SoundManager.shared.playUnicorn()

            case .bankrupt:
                SoundManager.shared.playBankruptcy()

            case .sold:
                SoundManager.shared.playSold()

            case .active:
                break
            }
        }
    }

    @ViewBuilder
    private var outcomeImage: some View {
        if gameViewModel.gameOutcome == .unicorn {
            ZStack {
                Circle()
                    .fill(
                        Color.white.opacity(0.12)
                    )
                    .frame(
                        width: 135,
                        height: 135
                    )

                Circle()
                    .stroke(
                        Color.white.opacity(0.25),
                        lineWidth: 3
                    )
                    .frame(
                        width: 135,
                        height: 135
                    )
                    .scaleEffect(
                        animateCelebration
                            ? 1.18
                            : 0.90
                    )
                    .opacity(
                        animateCelebration
                            ? 0
                            : 1
                    )
                    .animation(
                        .easeOut(duration: 1.4)
                            .repeatForever(
                                autoreverses: false
                            ),
                        value: animateCelebration
                    )

                Text("🦄")
                    .font(.system(size: 78))
                    .rotationEffect(
                        .degrees(
                            animateCelebration
                                ? 5
                                : -5
                        )
                    )
                    .scaleEffect(
                        animateCelebration
                            ? 1.07
                            : 0.95
                    )
                    .animation(
                        .easeInOut(duration: 0.8)
                            .repeatForever(
                                autoreverses: true
                            ),
                        value: animateCelebration
                    )
            }
        } else {
            Image(systemName: outcomeIcon)
                .font(.system(size: 78))
                .foregroundColor(outcomeColor)
        }
    }

    private var confettiLayer: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<24, id: \.self) { index in
                    confettiItem(
                        index: index,
                        size: geometry.size
                    )
                }
            }
        }
        .allowsHitTesting(false)
        .clipped()
    }

    private func confettiItem(
        index: Int,
        size: CGSize
    ) -> some View {
        let symbol =
            confettiSymbols[
                index % confettiSymbols.count
            ]

        let fontSize =
            CGFloat(14 + index % 10)

        let xPosition =
            confettiXPosition(
                index: index,
                width: size.width
            )

        let yPosition =
            animateCelebration
                ? size.height + 40
                : -40

        let rotation =
            animateCelebration
                ? Double(index * 90)
                : 0

        let duration =
            Double(4 + index % 4)

        let delay =
            Double(index) * 0.15

        return Text(symbol)
            .font(
                .system(size: fontSize)
            )
            .position(
                x: xPosition,
                y: yPosition
            )
            .rotationEffect(
                .degrees(rotation)
            )
            .animation(
                .linear(duration: duration)
                    .repeatForever(
                        autoreverses: false
                    )
                    .delay(delay),
                value: animateCelebration
            )
    }

    private var confettiSymbols: [String] {
        [
            "✨",
            "🎉",
            "⭐️",
            "💜",
            "💎",
            "🚀"
        ]
    }

    private func confettiXPosition(
        index: Int,
        width: CGFloat
    ) -> CGFloat {
        let spacing =
            width / 8

        return spacing *
            CGFloat((index % 8) + 1)
    }

    private var outcomeTitle: String {
        switch gameViewModel.gameOutcome {
        case .active:
            return "Game Over"

        case .bankrupt:
            return "Startup Bankrupt"

        case .unicorn:
            return "You Built a Unicorn!"

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
            Congratulations! Your startup reached a valuation of one billion dollars and officially joined the unicorn club. Investors may now use the word “disruptive” without irony.
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
            return .purple

        case .sold:
            return .green
        }
    }

    private var backgroundColors: [Color] {
        switch gameViewModel.gameOutcome {
        case .unicorn:
            return [
                Color(
                    red: 0.18,
                    green: 0.06,
                    blue: 0.30
                ),
                Color(
                    red: 0.43,
                    green: 0.12,
                    blue: 0.48
                ),
                Color(
                    red: 0.10,
                    green: 0.20,
                    blue: 0.42
                )
            ]

        default:
            return [
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
            ]
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
                .multilineTextAlignment(.trailing)
        }
    }

    private func formatCurrency(
        _ amount: Double
    ) -> String {
        CurrencyFormatter.compact(amount)
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

            game.company.marketValue =
                1_000_000_000

            game.gameOutcome = .unicorn

            return GameOverView(
                onReturnToMainMenu: {}
            )
            .environmentObject(game)
        }
    }
