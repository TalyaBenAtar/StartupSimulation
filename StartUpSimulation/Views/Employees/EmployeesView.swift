//
//  EmployeesView.swift
//  StartUpSimulation
//
//  Created by Talya Benatar on 15/07/2026.
//

import SwiftUI

struct EmployeesView: View {
    @EnvironmentObject private var gameViewModel: GameViewModel

    @State private var selectedSeniority: EmployeeSeniority = .junior
    @State private var candidates: [Employee] = []

    @State private var hiredCandidate: Employee?
    @State private var showHireConfirmation = false
    @State private var showCannotAffordAlert = false

    private let backgroundGradient = LinearGradient(
        colors: [
            Color(red: 0.08, green: 0.10, blue: 0.18),
            Color(red: 0.12, green: 0.20, blue: 0.32)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    var body: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 22) {
                    header

                    teamSummary

                    if gameViewModel.company.employees.isEmpty {
                        emptyTeamCard
                    } else {
                        currentTeamSection
                    }

                    senioritySection

                    candidateSection
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Employees")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if candidates.isEmpty {
                generateCandidates()
            }
        }
        .alert("Employee Hired", isPresented: $showHireConfirmation) {
            Button("Great!") {}
        } message: {
            if let hiredCandidate {
                Text(
                    "\(hiredCandidate.name) has joined your startup for \(CurrencyFormatter.exact(hiredCandidate.monthlySalary)) per month."
                )
            }
        }
        .alert("Not Enough Cash", isPresented: $showCannotAffordAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your startup cannot currently afford this employee.")
        }
    }

    private var header: some View {
        VStack(spacing: 8) {
            Image(systemName: "person.3.fill")
                .font(.system(size: 46))
                .foregroundColor(.purple)

            Text("Build Your Team")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)

            Text("Choose carefully. Talent is powerful, but payroll is undefeated.")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.65))
                .multilineTextAlignment(.center)
        }
        .padding(.top, 12)
    }

    private var teamSummary: some View {
        HStack(spacing: 12) {
            summaryItem(
                title: "Employees",
                value: "\(gameViewModel.company.employeeCount)",
                icon: "person.2.fill",
                color: .purple
            )

            summaryItem(
                title: "Salaries",
                value: formatCurrency(gameViewModel.company.salaryExpenses),
                icon: "banknote.fill",
                color: .red
            )
        }
    }

    private var emptyTeamCard: some View {
        VStack(spacing: 10) {
            Image(systemName: "person.crop.circle.badge.plus")
                .font(.largeTitle)
                .foregroundColor(.white.opacity(0.6))

            Text("You currently have no employees")
                .font(.headline)
                .foregroundColor(.white)

            Text("You are the founder, but hired employees will improve the product and help the company grow.")
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.08))
        )
    }

    private var currentTeamSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Current Team")
                .font(.headline)
                .foregroundColor(.white)

            ForEach(gameViewModel.company.employees) { employee in
                HiredEmployeeCard(employee: employee) {
                    _ = gameViewModel.fire(employee)
                }
                .environmentObject(gameViewModel)
            }
        }
    }

    private var senioritySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Choose Experience Level")
                .font(.headline)
                .foregroundColor(.white)

            ForEach(EmployeeSeniority.allCases) { seniority in
                Button {
                    selectedSeniority = seniority
                    generateCandidates()
                } label: {
                    SenioritySelectionCard(
                        seniority: seniority,
                        isSelected: selectedSeniority == seniority
                    )
                }
            }
        }
    }

    private var candidateSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("\(selectedSeniority.rawValue) Candidates")
                    .font(.headline)
                    .foregroundColor(.white)

                Spacer()

                Button {
                    generateCandidates()
                } label: {
                    Label("Refresh", systemImage: "arrow.clockwise")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.green)
                }
            }

            ForEach(candidates) { candidate in
                CandidateCard(
                    candidate: candidate,
                    canAfford: gameViewModel.canAfford(candidate)
                ) {
                    hire(candidate)
                }
            }
        }
    }

    private func summaryItem(
        title: String,
        value: String,
        icon: String,
        color: Color
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(color)

            Text(value)
                .font(.title3.bold())
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.75)

            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.10))
        )
    }

    private func generateCandidates() {
        candidates = CandidateFactory.generateCandidates(
            seniority: selectedSeniority
        )
    }

    private func hire(_ candidate: Employee) {
        guard gameViewModel.hire(candidate) else {
            showCannotAffordAlert = true
            return
        }

        hiredCandidate = candidate
        showHireConfirmation = true

        candidates.removeAll {
            $0.id == candidate.id
        }
    }

    private func formatCurrency(
        _ amount: Double
    ) -> String {
        CurrencyFormatter.compact(amount)
    }
}

struct SenioritySelectionCard: View {
    let seniority: EmployeeSeniority
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: seniority.iconName)
                .foregroundColor(isSelected ? .green : .white.opacity(0.75))
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 4) {
                Text(seniority.rawValue)
                    .font(.headline)
                    .foregroundColor(.white)

                Text(seniority.description)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.leading)
            }

            Spacer()

            Image(
                systemName: isSelected
                    ? "checkmark.circle.fill"
                    : "circle"
            )
            .foregroundColor(
                isSelected
                    ? .green
                    : .white.opacity(0.4)
            )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    Color.white.opacity(
                        isSelected ? 0.16 : 0.09
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    isSelected
                        ? Color.green
                        : Color.white.opacity(0.12),
                    lineWidth: isSelected ? 2 : 1
                )
        )
    }
}
struct CandidateCard: View {
    let candidate: Employee
    let canAfford: Bool
    let hireAction: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                HStack(spacing: 10) {
                    Image(systemName: candidate.role.iconName)
                        .foregroundColor(.green)
                        .frame(width: 28, height: 28)
                        .background(
                            Circle()
                                .fill(Color.green.opacity(0.12))
                        )

                    VStack(alignment: .leading, spacing: 3) {
                        Text(candidate.name)
                            .font(.headline)
                            .foregroundColor(.white)

                        Text(candidate.role.rawValue)
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.green)

                        Text(candidate.seniority.rawValue)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                    }
                }

                Spacer()

                Text("\(formatCurrency(candidate.monthlySalary))/mo")
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                    .multilineTextAlignment(.trailing)
            }

            Divider()
                .overlay(Color.white.opacity(0.15))

            infoRow(
                icon: "sparkles",
                title: candidate.trait
            )

            infoRow(
                icon: "bolt.fill",
                title: "Productivity: \(candidate.productivity)/10"
            )

            infoRow(
                icon: candidate.moraleImpact >= 0
                    ? "face.smiling.fill"
                    : "face.dashed.fill",
                title: moraleText
            )

            infoRow(
                icon: "briefcase.fill",
                title: "Hiring cost: \(formatCurrency(candidate.hiringCost))"
            )

            Text(candidate.role.description)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
                .fixedSize(horizontal: false, vertical: true)

            Text(candidate.personalNote)
                .font(.caption)
                .italic()
                .foregroundColor(.white.opacity(0.55))
                .fixedSize(horizontal: false, vertical: true)

            Button(action: hireAction) {
                Text(canAfford ? "Hire Candidate" : "Cannot Afford")
                    .font(.subheadline.bold())
                    .foregroundColor(
                        canAfford
                            ? .black
                            : .white.opacity(0.6)
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                canAfford
                                    ? Color.green
                                    : Color.gray.opacity(0.4)
                            )
                    )
            }
            .disabled(!canAfford)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.10))
        )
    }

    private var moraleText: String {
        let sign = candidate.moraleImpact >= 0 ? "+" : ""

        return "Team morale: \(sign)\(candidate.moraleImpact)"
    }

    private func infoRow(
        icon: String,
        title: String
    ) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(.green)
                .frame(width: 20)

            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
        }
    }

    private func formatCurrency(
        _ amount: Double
    ) -> String {
        CurrencyFormatter.compact(amount)
    }
}


struct HiredEmployeeCard: View {
    @EnvironmentObject private var gameViewModel: GameViewModel

    let employee: Employee
    let fireAction: () -> Void

    @State private var showFireConfirmation = false
    @State private var showCannotFireAlert = false

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: employee.role.iconName)
                .font(.title3)
                .foregroundColor(.purple)
                .frame(width: 38, height: 38)
                .background(
                    Circle()
                        .fill(Color.purple.opacity(0.14))
                )

            VStack(alignment: .leading, spacing: 3) {
                Text(employee.name)
                    .font(.subheadline.bold())
                    .foregroundColor(.white)

                Text(employee.role.rawValue)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.purple)

                Text(
                    "\(employee.seniority.rawValue) • \(formatCurrency(employee.monthlySalary))/mo"
                )
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
            }

            Spacer()

            Button {
                showFireConfirmation = true
            } label: {
                Image(systemName: "person.crop.circle.badge.minus")
                    .foregroundColor(.red)
                    .padding(8)
                    .background(
                        Circle()
                            .fill(Color.red.opacity(0.15))
                    )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.09))
        )
        .alert(
            "Fire \(employee.name)?",
            isPresented: $showFireConfirmation
        ) {
            Button("Cancel", role: .cancel) {}

            Button("Fire", role: .destructive) {
                fireAction()
            }
        } message: {
            Text(
                "This will cost \(formatCurrency(employee.severanceCost)) in severance and reduce team morale. Your cash balance may become negative."
            )
        }
        .alert(
            "Cannot Afford Severance",
            isPresented: $showCannotFireAlert
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(
                "Your startup needs \(formatCurrency(employee.severanceCost)) to fire this employee."
            )
        }
    }

    private func formatCurrency(
        _ amount: Double
    ) -> String {
        CurrencyFormatter.compact(amount)
    }
}


struct EmployeesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EmployeesView()
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
