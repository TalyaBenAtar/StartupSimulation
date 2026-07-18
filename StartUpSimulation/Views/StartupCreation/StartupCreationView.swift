//
//  StartupCreationView.swift
//  StartUpSimulation
//
//  Created by Talya Benatar on 15/07/2026.
//

import SwiftUI

struct StartupCreationView: View {
    @EnvironmentObject private var gameViewModel: GameViewModel
    let onReturnToMainMenu: () -> Void
    
    @State private var companyName = ""
    @State private var selectedIndustry: Industry = .artificialIntelligence
    @State private var founderInvestment: Double = 0
    
    @State private var startGame = false

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
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Image(systemName: "building.2.crop.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.green)

                        Text("Create Your Startup")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.white)

                        Text("Every unicorn starts with a questionable idea.")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 30)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Company Name")
                            .font(.headline)
                            .foregroundColor(.white)

                        TextField("Enter startup name", text: $companyName)
                            .padding()
                            .background(Color.white.opacity(0.12))
                            .foregroundColor(.white)
                            .cornerRadius(14)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Industry")
                            .font(.headline)
                            .foregroundColor(.white)

                        ForEach(Industry.allCases) { industry in
                            Button {
                                selectedIndustry = industry
                            } label: {
                                SelectionCard(
                                    title: industry.rawValue,
                                    description: industry.description,
                                    icon: industry.iconName,
                                    isSelected: selectedIndustry == industry
                                )
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Founder Investment")
                            .font(.headline)
                            .foregroundColor(.white)

                        Text(
                            "Your startup always starts with $150K. You may add some of your personal wealth."
                        )
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.65))

                        VStack(spacing: 10) {
                            HStack {
                                Text("Available Wealth")
                                    .foregroundColor(.white.opacity(0.7))

                                Spacer()

                                Text(
                                    formatCurrency(
                                        gameViewModel.playerProfile.founderWealth
                                    )
                                )
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                            }

                            HStack {
                                Text("Personal Investment")
                                    .foregroundColor(.white.opacity(0.7))

                                Spacer()

                                Text(formatCurrency(founderInvestment))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }

                            if maximumInvestment > 0 {
                                Slider(
                                    value: $founderInvestment,
                                    in: 0...maximumInvestment,
                                    step: investmentStep
                                )
                                .tint(.green)
                            } else {
                                HStack {
                                    Image(systemName: "lock.fill")

                                    Text(
                                        "Sell a startup to earn founder wealth and unlock personal investment."
                                    )
                                    .font(.caption)
                                }
                                .foregroundColor(.white.opacity(0.55))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 8)
                            }

                            HStack {
                                Text("$0")

                                Spacer()

                                Text(formatCurrency(maximumInvestment))
                            }
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.5))

                            Divider()
                                .overlay(Color.white.opacity(0.15))

                            HStack {
                                Text("Starting Company Cash")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)

                                Spacer()

                                Text(
                                    formatCurrency(
                                        150_000 + founderInvestment
                                    )
                                )
                                .font(.headline)
                                .foregroundColor(.green)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.09))
                        )
                    }

                    Button {
                        gameViewModel.startNewGame(
                            companyName: companyName,
                            industry: selectedIndustry,
                            founderInvestment: founderInvestment
                        )
                        
                        startGame = true

                        print("Started \(gameViewModel.company.name)")
                    } label: {
                        Text("Start Company")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(companyNameIsValid ? Color.green : Color.gray)
                            )
                    }
                    .disabled(!companyNameIsValid)
                    .padding(.top, 8)
                    .padding(.bottom, 30)
                }
                .padding(.horizontal, 24)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $startGame) {
            DashboardView(
                onReturnToMainMenu: onReturnToMainMenu
            )
            .environmentObject(gameViewModel)
        }
    }

    private var companyNameIsValid: Bool {
        !companyName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var maximumInvestment: Double {
        max(
            0,
            gameViewModel.playerProfile.founderWealth
        )
    }

    private var investmentStep: Double {
        maximumInvestment >= 10_000
        ? 1_000
        : 100
    }
    
    private func formatCurrency(
        _ amount: Double
    ) -> String {
        if amount >= 1_000_000_000 {
            return String(
                format: "$%.1fB",
                amount / 1_000_000_000
            )
        }

        if amount >= 1_000_000 {
            return String(
                format: "$%.1fM",
                amount / 1_000_000
            )
        }

        if amount >= 1_000 {
            return String(
                format: "$%.0fK",
                amount / 1_000
            )
        }

        return "$\(Int(amount))"
    }

}



struct SelectionCard: View {
    let title: String
    let description: String
    let icon: String
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(isSelected ? .green : .white.opacity(0.75))
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)

                Text(description)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.65))
                    .multilineTextAlignment(.leading)
            }

            Spacer()

            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isSelected ? .green : .white.opacity(0.4))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(isSelected ? 0.16 : 0.09))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    isSelected ? Color.green : Color.white.opacity(0.12),
                    lineWidth: isSelected ? 2 : 1
                )
        )
    }
}

struct StartupCreationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            StartupCreationView(
                onReturnToMainMenu: {}
            )
            .environmentObject(GameViewModel())
        }
    }
}
