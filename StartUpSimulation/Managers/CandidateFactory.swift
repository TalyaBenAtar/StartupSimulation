//
//  CandidateFactory.swift
//  StartUpSimulation
//
//  Created by Talya Benatar on 15/07/2026.
//

import Foundation

struct CandidateFactory {
    private static let names = [
        "Anna Cohen",
        "Adam Levi",
        "Maya Rosen",
        "Daniel Green",
        "Noa Shalev",
        "Ethan Miller",
        "Liam Brooks",
        "Sophie Turner",
        "Emma Stone",
        "Ryan Cooper",
        "Olivia Parker",
        "Lucas Reed",
        "Nina Davis",
        "Alex Morgan",
        "Sarah Klein"
    ]

    private static let traits: [
        (
            title: String,
            productivity: Int,
            morale: Int
        )
    ] = [
        ("Hard-Working", 9, 2),
        ("Creative Thinker", 8, 1),
        ("Team Player", 6, 5),
        ("Fast Learner", 7, 2),
        ("Perfectionist", 9, -2),
        ("Chronically Late", 4, -3),
        ("Natural Leader", 8, 4),
        ("Quiet but Reliable", 7, 1),
        ("Easily Distracted", 4, -1),
        ("Highly Ambitious", 9, 0),
        ("Office Comedian", 5, 5),
        ("Independent Worker", 8, 0)
    ]

    private static let personalNotes = [
        "Recently got married and expects two vacations each year.",
        "Adopted a new puppy and occasionally needs to work from home.",
        "Is caring for a family member and values flexible hours.",
        "Loves overtime when working on an exciting product.",
        "Is studying for an additional degree during evenings.",
        "Recently moved nearby and is available to start immediately.",
        "Has young children and strongly values predictable working hours.",
        "Wants to become a team leader in the future.",
        "Previously worked at a failed startup and understands the risks.",
        "Prefers remote work three days per week.",
        "Enjoys mentoring less experienced employees.",
        "Is willing to travel frequently for the company."
    ]

    static func generateCandidates(
        seniority: EmployeeSeniority,
        count: Int = 3
    ) -> [Employee] {
        let availableNames = names.shuffled()
        let availableTraits = traits.shuffled()
        let availableNotes = personalNotes.shuffled()
        let availableRoles = EmployeeRole.allCases.shuffled()

        return (0..<count).map { index in
            let trait = availableTraits[index % availableTraits.count]
            let role = availableRoles[index % availableRoles.count]

            return Employee(
                name: availableNames[index % availableNames.count],
                role: role,
                seniority: seniority,
                monthlySalary: randomizedSalary(for: seniority),
                hiringCost: seniority.hiringCost,
                trait: trait.title,
                personalNote: availableNotes[index % availableNotes.count],
                productivity: adjustedProductivity(
                    trait.productivity,
                    for: seniority
                ),
                moraleImpact: trait.morale
            )
        }
    }

    private static func randomizedSalary(
        for seniority: EmployeeSeniority
    ) -> Double {
        let range = seniority.salaryRange
        let salary = Int.random(in: range)

        return Double((salary / 500) * 500)
    }

    private static func adjustedProductivity(
        _ baseProductivity: Int,
        for seniority: EmployeeSeniority
    ) -> Int {
        let bonus: Int

        switch seniority {
        case .junior:
            bonus = -1

        case .midLevel:
            bonus = 1

        case .senior:
            bonus = 3
        }

        return min(max(baseProductivity + bonus, 1), 10)
    }
}
