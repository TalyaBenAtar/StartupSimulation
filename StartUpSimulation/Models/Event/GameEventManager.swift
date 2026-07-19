//
//  GameEventManager.swift
//  StartUpSimulation
//
//  Created by Talya Benatar on 19/07/2026.
//

import Foundation

struct GameEventManager {

    static let shared = GameEventManager()

    private init() {}

    let events: [GameEvent] = [

        GameEvent(
            title: "Critical Server Outage",

            description: """
            Your service has gone offline during peak usage. Customers are complaining, and every hour of downtime risks damaging your reputation.
            """,

            allowedStages: [
                .earlyStartup,
                .growingBusiness,
                .scaleUp
            ],

            choices: [
                EventChoice(
                    title: "Hire Emergency Specialists",

                    description: """
                    Bring in an external response team to repair the issue quickly. This is expensive, but it protects customers and your reputation.
                    """,

                    consequencePreview:
                        "High cost • Low risk • Protects brand",

                    cashChange: -25_000,
                    revenueChange: 2_000,
                    moraleChange: 2,
                    productChange: 3,
                    brandChange: 1,
                    marketValueChange: 40_000
                ),

                EventChoice(
                    title: "Let the Team Handle It",

                    description: """
                    Ask your current employees to resolve the outage. It costs less, but the team will be under pressure and recovery may take longer.
                    """,

                    consequencePreview:
                        "No direct cost • Medium risk • Team pressure",

                    cashChange: 0,
                    revenueChange: -3_000,
                    moraleChange: -4,
                    productChange: 1,
                    brandChange: -3,
                    marketValueChange: -30_000
                ),

                EventChoice(
                    title: "Wait It Out",

                    description: """
                    Avoid spending money and hope the issue resolves itself. This preserves cash now, but customers and investors may lose trust.
                    """,

                    consequencePreview:
                        "No cost • High risk • Reputation damage",

                    cashChange: 0,
                    revenueChange: -8_000,
                    moraleChange: -2,
                    productChange: -4,
                    brandChange: -10,
                    marketValueChange: -120_000
                )
            ]
        ),

        GameEvent(
            title: "Unexpected Viral Attention",

            description: """
            A popular creator mentioned your startup online. Thousands of people are suddenly visiting your website, but your infrastructure and support team may not be ready.
            """,

            allowedStages: [
                .idea,
                .earlyStartup,
                .growingBusiness
            ],

            choices: [
                EventChoice(
                    title: "Scale Immediately",

                    description: """
                    Spend money on infrastructure and customer support so the company can safely handle the sudden growth.
                    """,

                    consequencePreview:
                        "High cost • Low risk • Strong growth",

                    cashChange: -20_000,
                    revenueChange: 8_000,
                    moraleChange: 1,
                    productChange: 0,
                    brandChange: 10,
                    marketValueChange: 100_000
                ),

                EventChoice(
                    title: "Ride the Wave",

                    description: """
                    Accept the attention without making major investments. You may gain customers quickly, but technical problems could appear.
                    """,

                    consequencePreview:
                        "No cost • Medium risk • Good exposure",

                    cashChange: 0,
                    revenueChange: 4_000,
                    moraleChange: -2,
                    productChange: -2,
                    brandChange: 7,
                    marketValueChange: 45_000
                ),

                EventChoice(
                    title: "Limit New Sign-Ups",

                    description: """
                    Temporarily restrict access to protect the product. Growth will be slower, but the existing experience will remain stable.
                    """,

                    consequencePreview:
                        "Low risk • Slower growth • Protects product",

                    cashChange: 0,
                    revenueChange: 1_000,
                    moraleChange: 1,
                    productChange: 2,
                    brandChange: 2,
                    marketValueChange: 15_000
                )
            ]
        )
    ]

    func randomEvent(
        for stage: CompanyStage
    ) -> GameEvent? {
        let eligibleEvents =
            events.filter {
                $0.allowedStages.contains(stage)
            }

        return eligibleEvents.randomElement()
    }
}
