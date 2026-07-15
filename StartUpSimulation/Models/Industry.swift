//
//  Industry.swift
//  StartUpSimulation
//
//  Created by Talya Benatar on 15/07/2026.
//

import Foundation

enum Industry: String, CaseIterable, Identifiable, Codable {
    case artificialIntelligence = "Artificial Intelligence"
    case gaming = "Gaming"
    case healthcare = "Healthcare"
    case finance = "Finance"
    case socialMedia = "Social Media"

    var id: String {
        rawValue
    }

    var iconName: String {
        switch self {
        case .artificialIntelligence:
            return "brain.head.profile"

        case .gaming:
            return "gamecontroller.fill"

        case .healthcare:
            return "cross.case.fill"

        case .finance:
            return "dollarsign.circle.fill"

        case .socialMedia:
            return "person.3.fill"
        }
    }

    var description: String {
        switch self {
        case .artificialIntelligence:
            return "High growth potential, but expensive research and strong competition."

        case .gaming:
            return "Creative and unpredictable, with the possibility of viral success."

        case .healthcare:
            return "Stable demand, but development and regulations can be costly."

        case .finance:
            return "Strong revenue potential, but customers expect security and trust."

        case .socialMedia:
            return "Fast user growth is possible, but trends can change quickly."
        }
    }
}
