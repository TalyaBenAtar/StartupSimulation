//
//  ProductView.swift
//  StartUpSimulation
//
//  Created by Talya Benatar on 17/07/2026.
//

import SwiftUI

struct ProductView: View {

    @EnvironmentObject private var gameViewModel: GameViewModel
    @Environment(\.dismiss) private var dismiss

    private var maintenanceLoss: Int {
        switch gameViewModel.company.employeeCount {
        case 0:
            return 2
        case 1...3:
            return 1
        default:
            return 0
        }
    }
    
    private var decayDescription: String {

        switch gameViewModel.company.employeeCount {

        case 0:
            return "Without a development team, the product gradually becomes outdated as competitors continue improving their products."

        case 1...3:
            return "Your team maintains the product, but competitors and changing customer expectations still cause gradual quality decline."

        default:
            return "Your development team is large enough to fully maintain the product and keep pace with competitors."
        }
    }

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
                VStack(spacing: 20) {

                    VStack(spacing: 8) {
                        Text("📦 Product")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)

                        Text(
                            "Version \(company.majorVersion).\(company.minorVersion).\(company.patchVersion)"
                        )
                        .foregroundColor(.green)
                    }

                    infoCard(
                        title: "Product Quality",
                        value: "\(company.productQuality)%"
                    )

                    VStack(alignment: .leading, spacing: 8) {

                        Text("Monthly Product Decay")
                            .font(.headline)
                            .foregroundColor(.white)

                        Text("-\(maintenanceLoss)% Quality")
                            .font(.title2.bold())
                            .foregroundColor(.red)

                        Text(decayDescription)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.1))
                    )

                    actionButton(
                        title: "🩹 Bug Fix",
                        subtitle: "$2,000 • +2 Quality"
                    ) {
                        gameViewModel.fixBugs()
                    }

                    actionButton(
                        title: "✨ New Feature",
                        subtitle: "$8,000 • +6 Quality"
                    ) {
                        gameViewModel.developFeature()
                    }

                    actionButton(
                        title: "🚀 Major Release",
                        subtitle: "$20,000 • +15 Quality"
                    ) {
                        gameViewModel.majorRelease()
                    }

                    Spacer()
                }
                .padding()
            }
        }
        .navigationTitle("Product")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func infoCard(title: String, value: String) -> some View {
        VStack(spacing: 6) {
            Text(title)
                .foregroundColor(.white.opacity(0.7))

            Text(value)
                .font(.title.bold())
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
        )
    }

    private func actionButton(
        title: String,
        subtitle: String,
        action: @escaping () -> Void
    ) -> some View {

        Button(action: action) {

            VStack(alignment: .leading, spacing: 6) {

                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.65))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.10))
            )
        }
    }
}
