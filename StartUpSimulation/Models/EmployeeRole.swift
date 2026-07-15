//
//  EmployeeRole.swift
//  StartUpSimulation
//
//  Created by Talya Benatar on 15/07/2026.
//

import Foundation

enum EmployeeRole: String, CaseIterable, Identifiable, Codable {
    case softwareEngineer = "Software Engineer"
    case uiUxDesigner = "UI/UX Designer"
    case qaEngineer = "QA Engineer"
    case marketingSpecialist = "Marketing Specialist"
    case salesSpecialist = "Sales Specialist"
    case dataAnalyst = "Data Analyst"

    var id: String {
        rawValue
    }

    var iconName: String {
        switch self {
        case .softwareEngineer:
            return "chevron.left.forwardslash.chevron.right"

        case .uiUxDesigner:
            return "paintbrush.fill"

        case .qaEngineer:
            return "checkmark.seal.fill"

        case .marketingSpecialist:
            return "megaphone.fill"

        case .salesSpecialist:
            return "person.crop.circle.badge.checkmark"

        case .dataAnalyst:
            return "chart.bar.xaxis"
        }
    }

    var productContributionMultiplier: Double {
        switch self {
        case .softwareEngineer:
            return 1.0

        case .uiUxDesigner:
            return 0.8

        case .qaEngineer:
            return 0.9

        case .marketingSpecialist:
            return 0.2

        case .salesSpecialist:
            return 0.1

        case .dataAnalyst:
            return 0.4
        }
    }

    var revenueContributionMultiplier: Double {
        switch self {
        case .softwareEngineer:
            return 0.2

        case .uiUxDesigner:
            return 0.2

        case .qaEngineer:
            return 0.1

        case .marketingSpecialist:
            return 1.0

        case .salesSpecialist:
            return 1.2

        case .dataAnalyst:
            return 0.6
        }
    }

    var marketValueContributionMultiplier: Double {
        switch self {
        case .softwareEngineer:
            return 0.8

        case .uiUxDesigner:
            return 0.5

        case .qaEngineer:
            return 0.4

        case .marketingSpecialist:
            return 0.6

        case .salesSpecialist:
            return 0.7

        case .dataAnalyst:
            return 1.0
        }
    }

    var description: String {
        switch self {
        case .softwareEngineer:
            return "Builds features and improves the technical quality of the product."

        case .uiUxDesigner:
            return "Improves usability, design quality, and the customer experience."

        case .qaEngineer:
            return "Finds defects and helps keep product quality reliable."

        case .marketingSpecialist:
            return "Increases awareness, customer interest, and revenue potential."

        case .salesSpecialist:
            return "Turns interested customers into paying customers."

        case .dataAnalyst:
            return "Uses data to improve decisions, efficiency, and company valuation."
        }
    }
}
