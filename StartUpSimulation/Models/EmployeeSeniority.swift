//
//  EmployeeSeniority.swift
//  StartUpSimulation
//
//  Created by Talya Benatar on 15/07/2026.
//

import Foundation

enum EmployeeSeniority: String, CaseIterable, Identifiable, Codable {
    case junior = "Junior"
    case midLevel = "Mid-Level"
    case senior = "Senior"

    var id: String {
        rawValue
    }

    var salaryRange: ClosedRange<Int> {
        switch self {
        case .junior:
            return 5_000...8_000

        case .midLevel:
            return 9_000...14_000

        case .senior:
            return 15_000...22_000
        }
    }

    var hiringCost: Double {
        switch self {
        case .junior:
            return 2_000

        case .midLevel:
            return 4_000

        case .senior:
            return 7_000
        }
    }

    var iconName: String {
        switch self {
        case .junior:
            return "leaf.fill"

        case .midLevel:
            return "briefcase.fill"

        case .senior:
            return "crown.fill"
        }
    }

    var description: String {
        switch self {
        case .junior:
            return "Affordable and eager to learn, but requires guidance."

        case .midLevel:
            return "Balanced cost and experience with reliable productivity."

        case .senior:
            return "Highly productive and independent, but very expensive."
        }
    }
}
