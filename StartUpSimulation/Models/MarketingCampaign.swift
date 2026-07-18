//
//  MarketingCampaign.swift
//  StartUpSimulation
//
//  Created by Talya Benatar on 17/07/2026.
//

import Foundation

enum MarketingCampaign: String, CaseIterable, Identifiable, Codable {
    case socialMedia
    case paidAdvertising
    case marketingAgency

    var id: String {
        rawValue
    }

    var name: String {
        switch self {
        case .socialMedia:
            return "Social Media"

        case .paidAdvertising:
            return "Paid Advertising"

        case .marketingAgency:
            return "Marketing Agency"
        }
    }

    var iconName: String {
        switch self {
        case .socialMedia:
            return "bubble.left.and.bubble.right.fill"

        case .paidAdvertising:
            return "megaphone.fill"

        case .marketingAgency:
            return "person.3.fill"
        }
    }

    var description: String {
        switch self {
        case .socialMedia:
            return "An affordable campaign focused on online communities and social platforms."

        case .paidAdvertising:
            return "Targeted digital advertisements that reach a wider potential audience."

        case .marketingAgency:
            return "A professional agency manages strategy, content, and campaign execution."
        }
    }

    var riskLevel: String {
        switch self {
        case .socialMedia:
            return "Low variation"

        case .paidAdvertising:
            return "Moderate variation"

        case .marketingAgency:
            return "Moderate variation"
        }
    }

    var riskExplanation: String {
        switch self {
        case .socialMedia:
            return "Results are usually consistent, but the total audience is relatively limited."

        case .paidAdvertising:
            return "Results depend on customer interest and current market activity."

        case .marketingAgency:
            return "Professional management improves the potential result, but success still depends on the market."
        }
    }

    var oneTimeCost: Double {
        switch self {
        case .socialMedia:
            return 2_000

        case .paidAdvertising:
            return 6_000

        case .marketingAgency:
            return 15_000
        }
    }

    var oneTimeMinimumGain: Int {
        switch self {
        case .socialMedia:
            return 2

        case .paidAdvertising:
            return 5

        case .marketingAgency:
            return 10
        }
    }

    var oneTimeMaximumGain: Int {
        switch self {
        case .socialMedia:
            return 4

        case .paidAdvertising:
            return 8

        case .marketingAgency:
            return 14
        }
    }

    var monthlyCost: Double {
        switch self {
        case .socialMedia:
            return 1_500

        case .paidAdvertising:
            return 4_500

        case .marketingAgency:
            return 11_000
        }
    }

    var monthlyMinimumGain: Int {
        switch self {
        case .socialMedia:
            return 1

        case .paidAdvertising:
            return 3

        case .marketingAgency:
            return 7
        }
    }

    var monthlyMaximumGain: Int {
        switch self {
        case .socialMedia:
            return 3

        case .paidAdvertising:
            return 6

        case .marketingAgency:
            return 11
        }
    }

    var oneTimeGainRangeText: String {
        "+\(oneTimeMinimumGain)% to +\(oneTimeMaximumGain)%"
    }

    var monthlyGainRangeText: String {
        "+\(monthlyMinimumGain)% to +\(monthlyMaximumGain)% per month"
    }

    func generateOneTimeGain() -> Int {
        Int.random(
            in: oneTimeMinimumGain...oneTimeMaximumGain
        )
    }

    func generateMonthlyGain() -> Int {
        Int.random(
            in: monthlyMinimumGain...monthlyMaximumGain
        )
    }
}
