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

    var events: [GameEvent] {
        [

        // MARK: - Idea / Early Startup

        GameEvent(
            title: "Unexpected Viral Attention",
            description: """
            A popular creator mentioned your startup online. Thousands of people are suddenly visiting your website, but your infrastructure and support team may not be ready.
            """,
            allowedStages: [.idea, .earlyStartup, .growingBusiness],
            choices: [
                Self.makeChoice(
                    title: "Scale Immediately",
                    description: "Spend money on infrastructure and customer support so the company can safely handle the sudden growth.",
                    preview: "High cost • Low risk • Strong growth",
                    cash: -25_000 ... -15_000,
                    revenue: 6_000 ... 10_000,
                    morale: 0 ... 2,
                    product: 0 ... 2,
                    brand: 8 ... 12,
                    marketValue: 80_000 ... 130_000
                ),
                Self.makeChoice(
                    title: "Ride the Wave",
                    description: "Accept the attention without major investments. You may gain customers quickly, but technical problems could appear.",
                    preview: "No direct cost • Medium risk • Good exposure",
                    cash: 0 ... 0,
                    revenue: 2_000 ... 6_000,
                    morale: -3 ... -1,
                    product: -3 ... -1,
                    brand: 5 ... 9,
                    marketValue: 25_000 ... 65_000
                ),
                Self.makeChoice(
                    title: "Limit New Sign-Ups",
                    description: "Temporarily restrict access to protect the product. Growth will be slower, but the existing experience will remain stable.",
                    preview: "Low risk • Slower growth • Protects product",
                    cash: 0 ... 0,
                    revenue: 500 ... 2_000,
                    morale: 0 ... 2,
                    product: 1 ... 3,
                    brand: 1 ... 4,
                    marketValue: 8_000 ... 25_000
                )
            ]
        ),

        GameEvent(
            title: "Angel Investor Interest",
            description: """
            A successful entrepreneur wants to invest in your startup. The funding could accelerate growth, but the investor expects influence over major decisions.
            """,
            allowedStages: [.idea, .earlyStartup],
            choices: [
                Self.makeChoice(
                    title: "Accept the Full Investment",
                    description: "Accept the investor's full offer and use the new capital to grow faster.",
                    preview: "Major funding • Fast growth • Less independence",
                    cash: 70_000 ... 100_000,
                    revenue: 1_000 ... 4_000,
                    morale: 1 ... 3,
                    product: 1 ... 3,
                    brand: 2 ... 5,
                    marketValue: 90_000 ... 150_000
                ),
                Self.makeChoice(
                    title: "Negotiate a Smaller Deal",
                    description: "Take less money while keeping more control over the startup.",
                    preview: "Moderate funding • Balanced growth • More control",
                    cash: 35_000 ... 60_000,
                    revenue: 500 ... 2_500,
                    morale: 0 ... 2,
                    product: 0 ... 2,
                    brand: 1 ... 3,
                    marketValue: 40_000 ... 85_000
                ),
                Self.makeChoice(
                    title: "Decline the Offer",
                    description: "Keep full independence and continue building with your existing resources.",
                    preview: "No funding • Full control • Slower progress",
                    cash: 0 ... 0,
                    revenue: -500 ... 500,
                    morale: 0 ... 2,
                    product: 0 ... 2,
                    brand: -2 ... 0,
                    marketValue: -25_000 ... 10_000
                )
            ]
        ),

        GameEvent(
            title: "Government Innovation Grant",
            description: """
            A government program is offering financial support to promising technology startups. The application process will require time and documentation.
            """,
            allowedStages: [.idea, .earlyStartup],
            choices: [
                Self.makeChoice(
                    title: "Submit a Careful Application",
                    description: "Dedicate time to preparing a strong and realistic application with a high chance of approval.",
                    preview: "Moderate effort • Reliable funding • Good publicity",
                    cash: 40_000 ... 70_000,
                    revenue: 0 ... 1_500,
                    morale: 0 ... 2,
                    product: 0 ... 2,
                    brand: 2 ... 5,
                    marketValue: 35_000 ... 75_000
                ),
                Self.makeChoice(
                    title: "Chase the Maximum Grant",
                    description: "Apply for the largest possible grant. The reward is greater, but the proposal distracts the team from product work.",
                    preview: "High reward • High effort • Product distraction",
                    cash: 65_000 ... 110_000,
                    revenue: -1_000 ... 500,
                    morale: -2 ... 0,
                    product: -2 ... 0,
                    brand: 2 ... 6,
                    marketValue: 45_000 ... 95_000
                ),
                Self.makeChoice(
                    title: "Skip the Application",
                    description: "Avoid the paperwork and keep the entire team focused on building the company.",
                    preview: "No funding • No distraction • Product focus",
                    cash: 0 ... 0,
                    revenue: 0 ... 1_000,
                    morale: 0 ... 1,
                    product: 1 ... 3,
                    brand: -1 ... 1,
                    marketValue: 5_000 ... 25_000
                )
            ]
        ),

        // MARK: - Early Startup / Growing Business

        GameEvent(
            title: "Critical Server Outage",
            description: """
            Your service has gone offline during peak usage. Customers are complaining, and every hour of downtime risks damaging your reputation.
            """,
            allowedStages: [.earlyStartup, .growingBusiness, .scaleUp],
            choices: [
                Self.makeChoice(
                    title: "Hire Emergency Specialists",
                    description: "Bring in an external response team to repair the issue quickly. This is expensive, but it protects customers and your reputation.",
                    preview: "High cost • Low risk • Protects brand",
                    cash: -35_000 ... -20_000,
                    revenue: 1_000 ... 3_500,
                    morale: 1 ... 3,
                    product: 2 ... 4,
                    brand: 0 ... 3,
                    marketValue: 25_000 ... 60_000
                ),
                Self.makeChoice(
                    title: "Let the Team Handle It",
                    description: "Ask your current employees to resolve the outage. It costs less, but the team will be under pressure and recovery may take longer.",
                    preview: "No direct cost • Medium risk • Team pressure",
                    cash: 0 ... 0,
                    revenue: -5_000 ... -2_000,
                    morale: -6 ... -3,
                    product: 0 ... 2,
                    brand: -5 ... -2,
                    marketValue: -50_000 ... -20_000
                ),
                Self.makeChoice(
                    title: "Wait It Out",
                    description: "Avoid spending money and hope the issue resolves itself. This preserves cash now, but customers and investors may lose trust.",
                    preview: "No cost • High risk • Reputation damage",
                    cash: 0 ... 0,
                    revenue: -11_000 ... -7_000,
                    morale: -4 ... -1,
                    product: -6 ... -3,
                    brand: -13 ... -8,
                    marketValue: -160_000 ... -100_000
                )
            ]
        ),

        GameEvent(
            title: "Employee Burnout",
            description: """
            Your employees have been working under intense pressure for months. Productivity is slipping, and several team members are showing signs of burnout.
            """,
            allowedStages: [.earlyStartup, .growingBusiness, .scaleUp],
            choices: [
                Self.makeChoice(
                    title: "Give Everyone Paid Time Off",
                    description: "Pause nonessential work and give the team time to recover properly.",
                    preview: "Moderate cost • Strong morale recovery • Short delay",
                    cash: -22_000 ... -14_000,
                    revenue: -1_500 ... 500,
                    morale: 7 ... 11,
                    product: 1 ... 3,
                    brand: 0 ... 2,
                    marketValue: 10_000 ... 35_000
                ),
                Self.makeChoice(
                    title: "Pay Performance Bonuses",
                    description: "Reward the team financially and ask them to keep pushing through the difficult period.",
                    preview: "High cost • Moderate recovery • Work continues",
                    cash: -32_000 ... -20_000,
                    revenue: 500 ... 2_500,
                    morale: 4 ... 7,
                    product: 0 ... 2,
                    brand: 0 ... 1,
                    marketValue: 5_000 ... 25_000
                ),
                Self.makeChoice(
                    title: "Push Through the Deadline",
                    description: "Keep the current schedule and demand that everyone stay focused until the release is complete.",
                    preview: "No cost • High team risk • Faster short-term output",
                    cash: 0 ... 0,
                    revenue: 1_000 ... 3_000,
                    morale: -11 ... -7,
                    product: -4 ... -1,
                    brand: -3 ... -1,
                    marketValue: -90_000 ... -45_000
                )
            ]
        ),

        GameEvent(
            title: "Competitor Copies Your Feature",
            description: """
            A competitor has released a feature that looks suspiciously similar to your product's main advantage. Customers are beginning to compare both companies.
            """,
            allowedStages: [.earlyStartup, .growingBusiness, .scaleUp],
            choices: [
                Self.makeChoice(
                    title: "Take Legal Action",
                    description: "Hire lawyers and challenge the competitor. A strong response may protect your reputation, but legal action is expensive.",
                    preview: "Very high cost • Defensive move • Uncertain payoff",
                    cash: -55_000 ... -35_000,
                    revenue: -1_500 ... 1_000,
                    morale: -1 ... 2,
                    product: 0 ... 1,
                    brand: 1 ... 5,
                    marketValue: 15_000 ... 60_000
                ),
                Self.makeChoice(
                    title: "Build Something Better",
                    description: "Ignore the imitation and invest in making your own product clearly superior.",
                    preview: "Moderate cost • Product growth • Strong long-term value",
                    cash: -25_000 ... -12_000,
                    revenue: 1_000 ... 4_000,
                    morale: 1 ... 4,
                    product: 4 ... 7,
                    brand: 1 ... 4,
                    marketValue: 50_000 ... 95_000
                ),
                Self.makeChoice(
                    title: "Ignore the Competitor",
                    description: "Save your money and trust that customers will remain loyal without a direct response.",
                    preview: "No cost • High market risk • Possible customer loss",
                    cash: 0 ... 0,
                    revenue: -5_000 ... -2_000,
                    morale: -2 ... 0,
                    product: -3 ... -1,
                    brand: -5 ... -2,
                    marketValue: -80_000 ... -40_000
                )
            ]
        ),

        GameEvent(
            title: "Key Employee Wants Equity",
            description: """
            One of your strongest employees has received another job offer. They are willing to stay, but only if they receive a greater stake in the company's success.
            """,
            allowedStages: [.earlyStartup, .growingBusiness, .scaleUp],
            choices: [
                Self.makeChoice(
                    title: "Offer Company Equity",
                    description: "Give the employee a meaningful ownership stake and make them feel invested in the startup's future.",
                    preview: "No immediate cost • Strong retention • Shared ownership",
                    cash: 0 ... 0,
                    revenue: 1_000 ... 3_000,
                    morale: 5 ... 8,
                    product: 2 ... 5,
                    brand: 0 ... 2,
                    marketValue: 30_000 ... 65_000
                ),
                Self.makeChoice(
                    title: "Offer a Retention Bonus",
                    description: "Keep full ownership but pay a large one-time bonus to convince the employee to remain.",
                    preview: "High cash cost • Good retention • Full ownership",
                    cash: -25_000 ... -15_000,
                    revenue: 500 ... 2_000,
                    morale: 3 ... 6,
                    product: 1 ... 4,
                    brand: 0 ... 1,
                    marketValue: 10_000 ... 40_000
                ),
                Self.makeChoice(
                    title: "Let Them Leave",
                    description: "Refuse the demand and prepare the team to continue without the employee.",
                    preview: "No cost • Talent loss • Team disruption",
                    cash: 0 ... 0,
                    revenue: -3_500 ... -1_500,
                    morale: -7 ... -4,
                    product: -6 ... -3,
                    brand: -2 ... 0,
                    marketValue: -75_000 ... -40_000
                )
            ]
        ),

        GameEvent(
            title: "Office Flood",
            description: """
            A burst pipe has flooded your office overnight. Equipment was damaged, and the team needs a safe place to work.
            """,
            allowedStages: [.earlyStartup, .growingBusiness, .scaleUp],
            choices: [
                Self.makeChoice(
                    title: "Relocate Immediately",
                    description: "Pay for repairs and temporary office space so the team can return to normal work quickly.",
                    preview: "High cost • Fast recovery • Protects productivity",
                    cash: -40_000 ... -25_000,
                    revenue: -500 ... 1_000,
                    morale: 1 ... 4,
                    product: 0 ... 2,
                    brand: 0 ... 1,
                    marketValue: 5_000 ... 25_000
                ),
                Self.makeChoice(
                    title: "Work Remotely",
                    description: "Move the team online while arranging basic repairs. It is cheaper, but coordination may suffer.",
                    preview: "Low cost • Medium disruption • Flexible response",
                    cash: -10_000 ... -4_000,
                    revenue: -2_000 ... 500,
                    morale: -2 ... 1,
                    product: -2 ... 1,
                    brand: 0 ... 1,
                    marketValue: -20_000 ... 10_000
                ),
                Self.makeChoice(
                    title: "Delay Repairs",
                    description: "Keep expenses low and ask employees to work around the damage for now.",
                    preview: "No immediate cost • High disruption • Morale damage",
                    cash: 0 ... 0,
                    revenue: -4_000 ... -2_000,
                    morale: -7 ... -4,
                    product: -5 ... -2,
                    brand: -3 ... -1,
                    marketValue: -60_000 ... -30_000
                )
            ]
        ),

        // MARK: - Growing Business / Scale Up

        GameEvent(
            title: "Major Security Vulnerability",
            description: """
            A security researcher has privately discovered a serious vulnerability in your product. No customer data has been exposed yet, but the issue could become public.
            """,
            allowedStages: [.growingBusiness, .scaleUp],
            choices: [
                Self.makeChoice(
                    title: "Patch It Immediately",
                    description: "Stop planned work, hire security support, and release a thoroughly tested fix as quickly as possible.",
                    preview: "High cost • Low risk • Protects customer trust",
                    cash: -32_000 ... -20_000,
                    revenue: -1_000 ... 1_000,
                    morale: 0 ... 3,
                    product: 3 ... 6,
                    brand: 1 ... 4,
                    marketValue: 20_000 ... 60_000
                ),
                Self.makeChoice(
                    title: "Fix It Quietly",
                    description: "Ask the existing team to patch the issue without announcing it publicly.",
                    preview: "Low cost • Medium risk • Limited transparency",
                    cash: -8_000 ... -2_000,
                    revenue: -2_000 ... 500,
                    morale: -3 ... 0,
                    product: 1 ... 3,
                    brand: -5 ... -2,
                    marketValue: -55_000 ... -20_000
                ),
                Self.makeChoice(
                    title: "Delay the Fix",
                    description: "Continue with the current roadmap and hope the vulnerability is not discovered by anyone else.",
                    preview: "No cost • Extreme risk • Severe trust damage",
                    cash: 0 ... 0,
                    revenue: -8_000 ... -4_000,
                    morale: -5 ... -2,
                    product: -7 ... -4,
                    brand: -14 ... -9,
                    marketValue: -190_000 ... -120_000
                )
            ]
        ),

        GameEvent(
            title: "Enterprise Client Opportunity",
            description: """
            A large corporation wants to use your product across its entire organization. Winning the contract could transform the company, but their requirements are demanding.
            """,
            allowedStages: [.growingBusiness, .scaleUp],
            choices: [
                Self.makeChoice(
                    title: "Build Their Custom Features",
                    description: "Commit resources to the client's requirements and pursue the full enterprise contract.",
                    preview: "High cost • Major revenue • Product distraction",
                    cash: -50_000 ... -30_000,
                    revenue: 12_000 ... 20_000,
                    morale: -2 ... 1,
                    product: 1 ... 4,
                    brand: 4 ... 8,
                    marketValue: 140_000 ... 230_000
                ),
                Self.makeChoice(
                    title: "Offer the Standard Product",
                    description: "Refuse heavy customization but offer strong onboarding and support for the existing product.",
                    preview: "Moderate cost • Balanced growth • Product focus",
                    cash: -18_000 ... -8_000,
                    revenue: 6_000 ... 11_000,
                    morale: 0 ... 2,
                    product: 1 ... 3,
                    brand: 2 ... 5,
                    marketValue: 70_000 ... 130_000
                ),
                Self.makeChoice(
                    title: "Decline the Contract",
                    description: "Protect the roadmap and avoid becoming dependent on one powerful customer.",
                    preview: "No cost • Keeps independence • Missed growth",
                    cash: 0 ... 0,
                    revenue: -2_000 ... 0,
                    morale: 0 ... 2,
                    product: 1 ... 3,
                    brand: -2 ... 0,
                    marketValue: -45_000 ... 10_000
                )
            ]
        ),

        GameEvent(
            title: "Economic Recession",
            description: """
            The economy is slowing down. Customers are reducing spending, investors are becoming cautious, and your growth forecasts suddenly look optimistic.
            """,
            allowedStages: [.earlyStartup, .growingBusiness, .scaleUp],
            choices: [
                Self.makeChoice(
                    title: "Cut Operating Costs",
                    description: "Reduce nonessential spending and preserve cash until the market improves.",
                    preview: "Protects cash • Morale damage • Slower growth",
                    cash: 5_000 ... 15_000,
                    revenue: -4_000 ... -2_000,
                    morale: -6 ... -3,
                    product: -3 ... -1,
                    brand: -3 ... -1,
                    marketValue: -55_000 ... -20_000
                ),
                Self.makeChoice(
                    title: "Invest Through the Downturn",
                    description: "Keep building while competitors slow down, accepting higher short-term financial risk.",
                    preview: "High cost • Strategic risk • Strong recovery potential",
                    cash: -35_000 ... -20_000,
                    revenue: -2_000 ... 2_000,
                    morale: 1 ... 4,
                    product: 2 ... 5,
                    brand: 2 ... 5,
                    marketValue: 35_000 ... 90_000
                ),
                Self.makeChoice(
                    title: "Slash the Team Budget",
                    description: "Make severe reductions quickly to maximize runway, even though the decision will hurt employees and output.",
                    preview: "Large savings • Severe morale loss • Operational damage",
                    cash: 15_000 ... 30_000,
                    revenue: -7_000 ... -4_000,
                    morale: -13 ... -9,
                    product: -7 ... -4,
                    brand: -6 ... -3,
                    marketValue: -110_000 ... -65_000
                )
            ]
        ),

        GameEvent(
            title: "AI Productivity Tools",
            description: """
            New AI tools could automate repetitive work across engineering, support, and marketing. Adoption could improve productivity, but rushing it may create mistakes and concern employees.
            """,
            allowedStages: [.idea, .earlyStartup, .growingBusiness, .scaleUp],
            choices: [
                Self.makeChoice(
                    title: "Adopt Across the Company",
                    description: "Invest heavily in tools, training, and workflow changes across every department.",
                    preview: "High cost • High productivity • Change-management risk",
                    cash: -35_000 ... -22_000,
                    revenue: 3_000 ... 7_000,
                    morale: -2 ... 2,
                    product: 4 ... 7,
                    brand: 1 ... 4,
                    marketValue: 65_000 ... 120_000
                ),
                Self.makeChoice(
                    title: "Run a Small Pilot",
                    description: "Test the tools with a small group before deciding whether to expand their use.",
                    preview: "Low cost • Low risk • Moderate improvement",
                    cash: -12_000 ... -6_000,
                    revenue: 1_000 ... 3_500,
                    morale: 0 ... 3,
                    product: 2 ... 4,
                    brand: 0 ... 2,
                    marketValue: 25_000 ... 60_000
                ),
                Self.makeChoice(
                    title: "Keep Current Workflows",
                    description: "Avoid disruption and continue using the tools and processes your employees already understand.",
                    preview: "No cost • Stable morale • Competitive risk",
                    cash: 0 ... 0,
                    revenue: -1_500 ... 500,
                    morale: 0 ... 2,
                    product: -3 ... -1,
                    brand: -2 ... 0,
                    marketValue: -45_000 ... -15_000
                )
            ]
        ),

        GameEvent(
            title: "Major Partnership Proposal",
            description: """
            A well-known company wants to integrate your product into its platform. The partnership could expose you to millions of users, but they want favorable terms.
            """,
            allowedStages: [.growingBusiness, .scaleUp],
            choices: [
                Self.makeChoice(
                    title: "Accept Their Terms",
                    description: "Sign quickly and prioritize distribution, even though your share of the revenue will be smaller.",
                    preview: "Low negotiation risk • Major exposure • Lower margins",
                    cash: 15_000 ... 35_000,
                    revenue: 8_000 ... 14_000,
                    morale: 1 ... 3,
                    product: 0 ... 2,
                    brand: 8 ... 13,
                    marketValue: 120_000 ... 210_000
                ),
                Self.makeChoice(
                    title: "Negotiate Better Terms",
                    description: "Push for a more balanced agreement, accepting the risk that the partner may walk away.",
                    preview: "Medium risk • Better economics • Strong credibility",
                    cash: 5_000 ... 20_000,
                    revenue: 5_000 ... 11_000,
                    morale: 0 ... 3,
                    product: 0 ... 2,
                    brand: 5 ... 10,
                    marketValue: 90_000 ... 170_000
                ),
                Self.makeChoice(
                    title: "Remain Independent",
                    description: "Reject the partnership and keep full control over your product, customers, and pricing.",
                    preview: "Full control • No immediate gain • Missed exposure",
                    cash: 0 ... 0,
                    revenue: -1_000 ... 1_000,
                    morale: 0 ... 2,
                    product: 1 ... 3,
                    brand: -3 ... 0,
                    marketValue: -35_000 ... 20_000
                )
            ]
        )
        ]
    }

    func randomEvent(
        for stage: CompanyStage
    ) -> GameEvent? {
        let eligibleEvents = events.filter {
            $0.allowedStages.contains(stage)
        }

        return eligibleEvents.randomElement()
    }

    // MARK: - Randomized Event Choice Factory

    private static func makeChoice(
        title: String,
        description: String,
        preview: String,
        cash: ClosedRange<Double>,
        revenue: ClosedRange<Double>,
        morale: ClosedRange<Int>,
        product: ClosedRange<Int>,
        brand: ClosedRange<Int>,
        marketValue: ClosedRange<Double>
    ) -> EventChoice {
        let cashChange = Double.random(in: cash)
        let revenueChange = Double.random(in: revenue)
        let moraleChange = Int.random(in: morale)
        let productChange = Int.random(in: product)
        let brandChange = Int.random(in: brand)
        let marketValueChange = Double.random(in: marketValue)

        return EventChoice(
            title: title,
            description: description,
            consequencePreview: preview,
            cashChange: cashChange,
            revenueChange: revenueChange,
            moraleChange: moraleChange,
            productChange: productChange,
            brandChange: brandChange,
            marketValueChange: marketValueChange
        )
    }
}
