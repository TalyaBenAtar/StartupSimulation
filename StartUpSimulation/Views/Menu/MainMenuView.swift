//
//  ContentView.swift
//  StartUpSimulation
//
//  Created by Talya Benatar on 15/07/2026.
//

import SwiftUI

struct MainMenuView: View {
    var body: some View {
        NavigationStack {
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

                VStack(spacing: 24) {
                    Spacer()

                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 70))
                        .foregroundColor(.green)

                    Text("Startup Simulation")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)

                    Text("Build it. Grow it. Survive it.")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.75))

                    Spacer()

                    VStack(spacing: 16) {
                        NavigationLink {
                            StartupCreationView()
                        } label: {
                            MenuButtonContent(
                                title: "New Game",
                                icon: "plus.circle.fill"
                            )
                        }

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
                                icon: "questionmark.circle.fill"
                            )
                        }
                    }

                    Spacer()
                }
                .padding(.horizontal, 30)
            }
            .navigationBarHidden(true)
        }
        
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
                .fill(Color.white.opacity(0.12))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.18), lineWidth: 1)
        )
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}
