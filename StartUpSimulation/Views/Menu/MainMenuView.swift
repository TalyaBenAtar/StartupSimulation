//
//  ContentView.swift
//  StartUpSimulation
//
//  Created by Talya Benatar on 15/07/2026.
//

import SwiftUI

struct MainMenuView: View {
    @EnvironmentObject private var gameViewModel: GameViewModel
    
    @State private var showStartupCreation = false
    @State private var founderName = ""
    
    @State private var showActiveStartupWarning = false
    @State private var openCreationAfterSale = false
    
    var body: some View {
        NavigationStack {
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
                    
                    Image(
                        systemName:
                            "chart.line.uptrend.xyaxis"
                    )
                    .font(.system(size: 70))
                    .foregroundColor(.green)
                    
                    Text("Startup Simulation")
                        .font(
                            .system(
                                size: 34,
                                weight: .bold
                            )
                        )
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text(
                        "Build it. Grow it. Survive it."
                    )
                    .font(.headline)
                    .foregroundColor(
                        .white.opacity(0.75)
                    )
                    
                    founderCard
                    
                    Spacer()
                    
                    VStack(spacing: 16) {
                        Button {
                            if gameViewModel.hasActiveStartup {
                                showActiveStartupWarning = true
                            } else {
                                showStartupCreation = true
                            }
                        } label: {
                            MenuButtonContent(
                                title: "New Game",
                                icon: "plus.circle.fill"
                            )
                        }
                        .disabled(
                            gameViewModel.playerProfile.name.isEmpty
                        )
                        .opacity(
                            gameViewModel.playerProfile.name.isEmpty
                            ? 0.5
                            : 1
                        )
                        
                        Button {
                            print("Continue tapped")
                        } label: {
                            MenuButtonContent(
                                title: "Continue",
                                icon: "play.circle.fill"
                            )
                        }
                        
                        Button {
                            print("How to Play tapped")
                        } label: {
                            MenuButtonContent(
                                title: "How to Play",
                                icon:
                                    "questionmark.circle.fill"
                            )
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 30)
            }
            .navigationBarHidden(true)
            .navigationDestination(
                isPresented: $showStartupCreation
            ) {
                StartupCreationView(
                    onReturnToMainMenu: {
                        showStartupCreation = false
                    }
                )
            }
            .confirmationDialog(
                "Active Startup",
                isPresented: $showActiveStartupWarning,
                titleVisibility: .visible
            ) {
                Button("Continue \(gameViewModel.company.name)") {
                    // Stay on the menu for now.
                    // Continue will be connected in the next step.
                }

                Button(
                    "Sell and Start New Startup",
                    role: .destructive
                ) {
                    gameViewModel.sellStartup()
                    openCreationAfterSale = true
                }

                Button("Cancel", role: .cancel) {
                }
            } message: {
                Text(
                    """
                    You can only manage one startup at a time. Continue your current startup or sell it before creating a new one.
                    """
                )
            }
            .onChange(of: openCreationAfterSale) { shouldOpen in
                guard shouldOpen else {
                    return
                }

                gameViewModel.company = .empty
                gameViewModel.gameOutcome = .active

                showStartupCreation = true
                openCreationAfterSale = false
            }
        }
    }
        
        private var founderCard: some View {
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 42))
                        .foregroundColor(.green)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(
                            gameViewModel.playerProfile.name.isEmpty
                            ? "Create Founder Profile"
                            : gameViewModel.playerProfile.name
                        )
                        .font(.headline)
                        .foregroundColor(.white)
                        
                        Text(
                            "Founder Wealth: \(formatCurrency(gameViewModel.playerProfile.founderWealth))"
                        )
                        .font(.subheadline)
                        .foregroundColor(.green)
                    }
                    
                    Spacer()
                }
                
                if gameViewModel.playerProfile.name.isEmpty {
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
                            .frame(maxWidth: .infinity)
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
                    .disabled(!founderNameIsValid)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white.opacity(0.10))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(
                        Color.green.opacity(0.35),
                        lineWidth: 1
                    )
            )
        }
        
        private var founderNameIsValid: Bool {
            !founderName
                .trimmingCharacters(
                    in: .whitespacesAndNewlines
                )
                .isEmpty
        }
        
        private func saveFounderName() {
            gameViewModel.playerProfile.name =
            founderName.trimmingCharacters(
                in: .whitespacesAndNewlines
            )
            
            founderName = ""
        }
        
        private func formatCurrency(
            _ amount: Double
        ) -> String {
            let absoluteAmount = abs(amount)
            
            if absoluteAmount >= 1_000_000_000 {
                return String(
                    format: "$%.1fB",
                    absoluteAmount / 1_000_000_000
                )
            }
            
            if absoluteAmount >= 1_000_000 {
                return String(
                    format: "$%.1fM",
                    absoluteAmount / 1_000_000
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
    }


struct MenuButtonContent: View {
    let title: String
    let icon: String

    var body: some View {
        HStack {
            Image(systemName: icon)

            Text(title)
                .fontWeight(.semibold)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
        }
        .foregroundColor(.white)
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    Color.white.opacity(0.12)
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    Color.white.opacity(0.18),
                    lineWidth: 1
                )
        )
    }
}

struct MainMenuView_Previews:
    PreviewProvider {

    static var previews: some View {
        MainMenuView()
            .environmentObject(
                GameViewModel()
            )
    }
}
