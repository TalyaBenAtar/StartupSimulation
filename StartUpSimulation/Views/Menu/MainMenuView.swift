//
//  MainMenuView.swift
//  StartUpSimulation
//
//  Created by Talya Benatar on 15/07/2026.
//

import SwiftUI

struct MainMenuView: View {

    @EnvironmentObject private var gameViewModel:
        GameViewModel

    @State private var founderName =
        ""

    @State private var showStartupCreation =
        false

    @State private var showDashboard =
        false

    @State private var showFounderProfile =
        false

    @State private var showExistingStartupWarning =
        false

    @State private var showSellConfirmation =
        false

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient

                VStack(spacing: 24) {
                    Spacer()

                    gameTitle

                    founderCard

                    Spacer()

                    menuButtons

                    Spacer()
                }
                .padding(
                    .horizontal,
                    30
                )
            }
            .navigationBarHidden(true)

            // MARK: - Startup Creation Navigation

            .navigationDestination(
                isPresented:
                    $showStartupCreation
            ) {
                StartupCreationView(
                    onReturnToMainMenu: {
                        showStartupCreation =
                            false
                    }
                )
                .environmentObject(
                    gameViewModel
                )
            }

            // MARK: - Continue Navigation

            .navigationDestination(
                isPresented:
                    $showDashboard
            ) {
                DashboardView(
                    onReturnToMainMenu: {
                        showDashboard =
                            false
                    }
                )
                .environmentObject(
                    gameViewModel
                )
            }

            // MARK: - Founder Navigation

            .navigationDestination(
                isPresented:
                    $showFounderProfile
            ) {
                FounderView()
                    .environmentObject(
                        gameViewModel
                    )
            }

            // MARK: - Existing Startup Warning

            .confirmationDialog(
                "You Already Have a Startup",
                isPresented:
                    $showExistingStartupWarning,
                titleVisibility:
                    .visible
            ) {
                Button(
                    "Keep \(gameViewModel.company.name)"
                ) {
                }

                Button(
                    "Sell \(gameViewModel.company.name)",
                    role: .destructive
                ) {
                    showSellConfirmation =
                        true
                }

                Button(
                    "Cancel",
                    role: .cancel
                ) {
                }

            } message: {
                Text(
                    """
                    You can only manage one active startup at a time. To create a new company, you must first sell your current startup.
                    """
                )
            }

            // MARK: - Sell Confirmation

            .confirmationDialog(
                "Sell \(gameViewModel.company.name)?",
                isPresented:
                    $showSellConfirmation,
                titleVisibility:
                    .visible
            ) {
                Button(
                    "Sell for \(formatCurrency(gameViewModel.company.marketValue))",
                    role: .destructive
                ) {
                    sellStartupAndCreateNew()
                }

                Button(
                    "Cancel",
                    role: .cancel
                ) {
                }

            } message: {
                Text(
                    """
                    Selling ends your current simulation. The sale value will be added to your founder wealth, and you will then create a new startup.
                    """
                )
            }
        }
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

    // MARK: - Game Title

    private var gameTitle: some View {
        VStack(spacing: 14) {
            Image(
                systemName:
                    "chart.line.uptrend.xyaxis"
            )
            .font(
                .system(size: 70)
            )
            .foregroundColor(.green)

            Text("Startup Simulation")
                .font(
                    .system(
                        size: 34,
                        weight: .bold
                    )
                )
                .foregroundColor(.white)
                .multilineTextAlignment(
                    .center
                )

            Text(
                "Build it. Grow it. Survive it."
            )
            .font(.headline)
            .foregroundColor(
                .white.opacity(0.75)
            )
        }
    }

    // MARK: - Founder Card

    private var founderCard: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Image(
                    systemName:
                        "person.crop.circle.fill"
                )
                .font(
                    .system(size: 42)
                )
                .foregroundColor(.green)

                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {
                    Text(founderDisplayName)
                        .font(.headline)
                        .foregroundColor(.white)

                    Text(
                        "Founder Wealth: \(formatCurrency(gameViewModel.playerProfile.founderWealth))"
                    )
                    .font(.subheadline)
                    .foregroundColor(.green)

                    if founderProfileExists {
                        Text(
                            "View career statistics"
                        )
                        .font(.caption)
                        .foregroundColor(
                            .white.opacity(0.55)
                        )
                    }
                }

                Spacer()

                if founderProfileExists {
                    Image(
                        systemName:
                            "chevron.right"
                    )
                    .font(.caption.bold())
                    .foregroundColor(
                        .white.opacity(0.45)
                    )
                }
            }

            if !founderProfileExists {
                founderCreationControls
            }
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
                Color.green.opacity(0.35),
                lineWidth: 1
            )
        )
        .contentShape(
            RoundedRectangle(
                cornerRadius: 18
            )
        )
        .onTapGesture {
            guard founderProfileExists
            else {
                return
            }

            showFounderProfile =
                true
        }
    }

    private var founderDisplayName: String {
        if !founderProfileExists {
            return "Create Founder Profile"
        }

        return gameViewModel
            .playerProfile
            .name
    }

    private var founderCreationControls: some View {
        VStack(spacing: 12) {
            TextField(
                "Enter founder name",
                text: $founderName
            )
            .padding()
            .background(
                Color.white.opacity(0.10)
            )
            .foregroundColor(.white)
            .cornerRadius(12)

            Button {
                saveFounderName()
            } label: {
                Text("Create Founder")
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .frame(
                        maxWidth: .infinity
                    )
                    .padding()
                    .background(
                        RoundedRectangle(
                            cornerRadius: 12
                        )
                        .fill(
                            founderNameIsValid
                            ? Color.green
                            : Color.gray
                        )
                    )
            }
            .disabled(
                !founderNameIsValid
            )
        }
    }

    // MARK: - Menu Buttons

    private var menuButtons: some View {
        VStack(spacing: 16) {
            Button {
                handleNewGameTapped()
            } label: {
                MenuButtonContent(
                    title: "New Game",
                    icon:
                        "plus.circle.fill"
                )
            }
            .disabled(
                !founderProfileExists
            )
            .opacity(
                founderProfileExists
                ? 1
                : 0.5
            )

            Button {
                showDashboard =
                    true
            } label: {
                MenuButtonContent(
                    title:
                        continueButtonTitle,
                    icon:
                        "play.circle.fill"
                )
            }
            .disabled(
                !gameViewModel
                    .hasActiveStartup
            )
            .opacity(
                gameViewModel
                    .hasActiveStartup
                ? 1
                : 0.5
            )

            Button {
                print(
                    "How to Play tapped"
                )
            } label: {
                MenuButtonContent(
                    title: "How to Play",
                    icon:
                        "questionmark.circle.fill"
                )
            }
        }
    }

    private var continueButtonTitle: String {
        guard gameViewModel
            .hasActiveStartup
        else {
            return "Continue"
        }

        return "Continue \(gameViewModel.company.name)"
    }

    // MARK: - Menu Actions

    private func handleNewGameTapped() {
        if gameViewModel
            .hasActiveStartup {

            showExistingStartupWarning =
                true

        } else {
            showStartupCreation =
                true
        }
    }

    private func sellStartupAndCreateNew() {
        gameViewModel.sellStartup()

        showStartupCreation =
            true
    }

    // MARK: - Founder Name

    private var founderProfileExists: Bool {
        !gameViewModel
            .playerProfile
            .name
            .isEmpty
    }

    private var founderNameIsValid: Bool {
        !founderName
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
            .isEmpty
    }

    private func saveFounderName() {
        gameViewModel.createFounder(
            name: founderName
        )

        founderName = ""
    }

    // MARK: - Formatting

    private func formatCurrency(
        _ amount: Double
    ) -> String {
        let isNegative =
            amount < 0

        let absoluteAmount =
            abs(amount)

        let formattedAmount: String

        if absoluteAmount >=
            1_000_000_000 {

            formattedAmount =
                String(
                    format: "$%.1fB",
                    absoluteAmount /
                        1_000_000_000
                )

        } else if absoluteAmount >=
                    1_000_000 {

            formattedAmount =
                String(
                    format: "$%.1fM",
                    absoluteAmount /
                        1_000_000
                )

        } else if absoluteAmount >=
                    1_000 {

            formattedAmount =
                String(
                    format: "$%.0fK",
                    absoluteAmount /
                        1_000
                )

        } else {
            formattedAmount =
                "$\(Int(absoluteAmount))"
        }

        return isNegative
            ? "-\(formattedAmount)"
            : formattedAmount
    }
}

// MARK: - Menu Button

struct MenuButtonContent: View {

    let title: String
    let icon: String

    var body: some View {
        HStack {
            Image(
                systemName: icon
            )

            Text(title)
                .fontWeight(.semibold)
                .lineLimit(1)
                .minimumScaleFactor(0.75)

            Spacer()

            Image(
                systemName:
                    "chevron.right"
            )
            .font(.caption)
        }
        .foregroundColor(.white)
        .padding()
        .frame(
            maxWidth: .infinity
        )
        .background(
            RoundedRectangle(
                cornerRadius: 16
            )
            .fill(
                Color.white.opacity(0.12)
            )
        )
        .overlay(
            RoundedRectangle(
                cornerRadius: 16
            )
            .stroke(
                Color.white.opacity(0.18),
                lineWidth: 1
            )
        )
    }
}

// MARK: - Preview

struct MainMenuView_Previews:
    PreviewProvider {

    static var previews: some View {
        MainMenuView()
            .environmentObject(
                GameViewModel()
            )
    }
}
