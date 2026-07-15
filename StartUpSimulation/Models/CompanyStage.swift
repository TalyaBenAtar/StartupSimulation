//
//  CompanyStage.swift
//  StartUpSimulation
//
//  Created by Talya Benatar on 15/07/2026.
//

import Foundation

enum CompanyStage: String, Codable {
    case idea = "Idea Stage"
    case earlyStartup = "Early Startup"
    case growingBusiness = "Growing Business"
    case scaleUp = "Scale-Up"
    case unicorn = "Unicorn"

    var nextGoalDescription: String {
        switch self {
        case .idea:
            return "Reach a market value of $1M"
        case .earlyStartup:
            return "Reach a market value of $10M"
        case .growingBusiness:
            return "Reach a market value of $100M"
        case .scaleUp:
            return "Reach a market value of $1B"
        case .unicorn:
            return "You built a unicorn!"
        }
    }

    static func stage(for marketValue: Double) -> CompanyStage {
        switch marketValue {
        case 1_000_000_000...:
            return .unicorn

        case 100_000_000...:
            return .scaleUp

        case 10_000_000...:
            return .growingBusiness

        case 1_000_000...:
            return .earlyStartup

        default:
            return .idea
        }
    }
}
