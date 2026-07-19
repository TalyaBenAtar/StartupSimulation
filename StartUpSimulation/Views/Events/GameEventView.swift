//
//  GameEventView.swift
//  StartUpSimulation
//
//  Created by Talya Benatar on 19/07/2026.
//

import SwiftUI

struct GameEventView: View {
    @EnvironmentObject private var gameViewModel: GameViewModel

    let event: GameEvent

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
                    eventHeader

                    ForEach(event.choices) { choice in
                        choiceCard(choice)
                    }
                }
                .padding(24)
            }
        }
        .interactiveDismissDisabled(true)
    }

    private var eventHeader: some View {
        VStack(spacing: 14) {
            Image(systemName: "exclamationmark.bubble.fill")
                .font(.system(size: 52))
                .foregroundColor(.orange)

            Text("Startup Event")
                .font(.subheadline.bold())
                .foregroundColor(.orange)

            Text(event.title)
                .font(.largeTitle.bold())
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            Text(event.description)
                .font(.body)
                .foregroundColor(.white.opacity(0.75))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
    }

    private func choiceCard(
        _ choice: EventChoice
    ) -> some View {
        VStack(
            alignment: .leading,
            spacing: 14
        ) {
            Text(choice.title)
                .font(.headline)
                .foregroundColor(.white)

            Text(choice.description)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
                .lineSpacing(3)

            Text(choice.consequencePreview)
                .font(.caption.bold())
                .foregroundColor(.orange)

            consequenceSection(choice)

            Button {
                gameViewModel.chooseEventOption(
                    choice
                )
            } label: {
                Text("Choose This Option")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(
                            cornerRadius: 14
                        )
                        .fill(Color.green)
                    )
            }
        }
        .padding()
        .background(
            RoundedRectangle(
                cornerRadius: 18
            )
            .fill(Color.white.opacity(0.10))
        )
        .overlay(
            RoundedRectangle(
                cornerRadius: 18
            )
            .stroke(
                Color.white.opacity(0.12),
                lineWidth: 1
            )
        )
    }

    private func consequenceSection(
        _ choice: EventChoice
    ) -> some View {
        VStack(
            alignment: .leading,
            spacing: 8
        ) {
            Text("Known Consequences")
                .font(.caption.bold())
                .foregroundColor(.white.opacity(0.55))

            if choice.cashChange != 0 {
                consequenceRow(
                    title: "Cash",
                    value: formatCurrencyChange(
                        choice.cashChange
                    ),
                    isPositive:
                        choice.cashChange > 0
                )
            }

            if choice.revenueChange != 0 {
                consequenceRow(
                    title: "Monthly Revenue",
                    value: formatCurrencyChange(
                        choice.revenueChange
                    ),
                    isPositive:
                        choice.revenueChange > 0
                )
            }

            if choice.moraleChange != 0 {
                consequenceRow(
                    title: "Morale",
                    value: formatNumberChange(
                        choice.moraleChange
                    ),
                    isPositive:
                        choice.moraleChange > 0
                )
            }

            if choice.productChange != 0 {
                consequenceRow(
                    title: "Product",
                    value: formatNumberChange(
                        choice.productChange
                    ),
                    isPositive:
                        choice.productChange > 0
                )
            }

            if choice.brandChange != 0 {
                consequenceRow(
                    title: "Brand",
                    value: formatNumberChange(
                        choice.brandChange
                    ),
                    isPositive:
                        choice.brandChange > 0
                )
            }

            if choice.marketValueChange != 0 {
                consequenceRow(
                    title: "Market Value",
                    value: formatCurrencyChange(
                        choice.marketValueChange
                    ),
                    isPositive:
                        choice.marketValueChange > 0
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(
                cornerRadius: 12
            )
            .fill(Color.black.opacity(0.18))
        )
    }

    private func consequenceRow(
        title: String,
        value: String,
        isPositive: Bool
    ) -> some View {
        HStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))

            Spacer()

            Text(value)
                .font(.caption.bold())
                .foregroundColor(
                    isPositive ? .green : .red
                )
        }
    }

    private func formatNumberChange(
        _ value: Int
    ) -> String {
        "\(value > 0 ? "+" : "")\(value)%"
    }

    private func formatCurrencyChange(
        _ value: Double
    ) -> String {
        CurrencyFormatter.compact(
            value,
            showSign: true
        )
    }
}
