//
//  MarketingView.swift
//  StartUpSimulation
//
//  Created by Talya Benatar on 17/07/2026.
//

import SwiftUI

struct MarketingView: View {
    @ObservedObject var gameViewModel: GameViewModel

    @State private var selectedOneTimeCampaign:
        MarketingCampaign?

    @State private var selectedMonthlyCampaign:
        MarketingCampaign?

    @State private var showingOneTimeConfirmation = false
    @State private var showingMonthlyConfirmation = false
    @State private var showingCancelConfirmation = false

    @State private var resultMessage: String?
    @State private var showingResult = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(
                        red: 0.08,
                        green: 0.10,
                        blue: 0.18
                    ),
                    Color(
                        red: 0.12,
                        green: 0.20,
                        blue: 0.32
                    )
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 18) {
                    awarenessCard
                    activeSubscriptionCard
                    latestResultCard
                    informationCard

                    ForEach(
                        MarketingCampaign.allCases
                    ) { campaign in
                        campaignCard(campaign)
                    }
                }
                .padding(.horizontal, 18)
                .padding(.top, 14)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Marketing")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog(
            oneTimeConfirmationTitle,
            isPresented:
                $showingOneTimeConfirmation,
            titleVisibility: .visible
        ) {
            if let campaign =
                selectedOneTimeCampaign {

                Button(
                    "Run Campaign for \(currency(campaign.oneTimeCost))"
                ) {
                    runOneTimeCampaign(campaign)
                }

                Button(
                    "Cancel",
                    role: .cancel
                ) {}
            }
        } message: {
            if let campaign =
                selectedOneTimeCampaign {

                Text(
                    """
                    Expected result: \(campaign.oneTimeGainRangeText)

                    The result will be applied immediately. This campaign does not renew automatically.
                    """
                )
            }
        }
        .confirmationDialog(
            monthlyConfirmationTitle,
            isPresented:
                $showingMonthlyConfirmation,
            titleVisibility: .visible
        ) {
            if let campaign =
                selectedMonthlyCampaign {

                Button(
                    monthlyConfirmationButtonTitle(
                        for: campaign
                    )
                ) {
                    activateMonthlyCampaign(
                        campaign
                    )
                }

                Button(
                    "Cancel",
                    role: .cancel
                ) {}
            }
        } message: {
            if let campaign =
                selectedMonthlyCampaign {

                Text(
                    monthlyConfirmationMessage(
                        for: campaign
                    )
                )
            }
        }
        .confirmationDialog(
            "Cancel Monthly Marketing?",
            isPresented:
                $showingCancelConfirmation,
            titleVisibility: .visible
        ) {
            Button(
                "Cancel Subscription",
                role: .destructive
            ) {
                cancelMonthlyCampaign()
            }

            Button(
                "Keep Subscription",
                role: .cancel
            ) {}
        } message: {
            if let campaign =
                gameViewModel.company
                    .activeMonthlyMarketingCampaign {

                Text(
                    """
                    \(campaign.name) will stop immediately.

                    You will not be charged \(currency(campaign.monthlyCost)) at the next month end. Brand Awareness will decline by 1% each month without an active subscription.
                    """
                )
            }
        }
        .alert(
            "Marketing Result",
            isPresented: $showingResult
        ) {
            Button(
                "OK",
                role: .cancel
            ) {}
        } message: {
            Text(resultMessage ?? "")
        }
    }

    private var awarenessCard: some View {
        VStack(spacing: 14) {
            HStack {
                Label(
                    "Brand Awareness",
                    systemImage:
                        "person.2.wave.2.fill"
                )
                .font(.headline)
                .foregroundColor(.white)

                Spacer()

                Text(
                    "\(gameViewModel.company.brandAwareness)%"
                )
                .font(.title2.bold())
                .foregroundColor(.green)
            }

            ProgressView(
                value: Double(
                    gameViewModel.company
                        .brandAwareness
                ),
                total: 100
            )
            .tint(.green)

            Text(
                "Brand Awareness represents how many potential customers recognize your startup. It will influence customer growth and revenue."
            )
            .font(.caption)
            .foregroundColor(
                .white.opacity(0.65)
            )
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
        }
        .padding()
        .background(cardBackground)
        .overlay(cardBorder)
    }

    @ViewBuilder
    private var activeSubscriptionCard:
        some View {

        if let activeCampaign =
            gameViewModel.company
                .activeMonthlyMarketingCampaign {

            VStack(
                alignment: .leading,
                spacing: 14
            ) {
                HStack {
                    Label(
                        "Active Monthly Campaign",
                        systemImage:
                            "repeat.circle.fill"
                    )
                    .font(.headline)
                    .foregroundColor(.white)

                    Spacer()

                    Text("ACTIVE")
                        .font(.caption.bold())
                        .foregroundColor(.green)
                        .padding(
                            .horizontal,
                            9
                        )
                        .padding(
                            .vertical,
                            5
                        )
                        .background(
                            Capsule()
                                .fill(
                                    Color.green
                                        .opacity(0.15)
                                )
                        )
                }

                HStack(spacing: 12) {
                    Image(
                        systemName:
                            activeCampaign.iconName
                    )
                    .font(.title2)
                    .foregroundColor(.orange)
                    .frame(
                        width: 42,
                        height: 42
                    )
                    .background(
                        RoundedRectangle(
                            cornerRadius: 12
                        )
                        .fill(
                            Color.orange
                                .opacity(0.15)
                        )
                    )

                    VStack(
                        alignment: .leading,
                        spacing: 4
                    ) {
                        Text(
                            activeCampaign.name
                        )
                        .font(.headline)
                        .foregroundColor(.white)

                        Text(
                            "\(currency(activeCampaign.monthlyCost)) per month"
                        )
                        .font(.subheadline)
                        .foregroundColor(
                            .white.opacity(0.6)
                        )
                    }

                    Spacer()
                }

                subscriptionDetailRow(
                    title: "Expected result",
                    value:
                        activeCampaign
                            .monthlyGainRangeText
                )

                subscriptionDetailRow(
                    title: "Billing",
                    value:
                        "Charged when the month ends"
                )

                Button {
                    showingCancelConfirmation = true
                } label: {
                    Text(
                        "Cancel Subscription"
                    )
                    .fontWeight(.semibold)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 11)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 12
                        )
                        .fill(
                            Color.red.opacity(0.12)
                        )
                    )
                    .overlay(
                        RoundedRectangle(
                            cornerRadius: 12
                        )
                        .stroke(
                            Color.red.opacity(0.5),
                            lineWidth: 1
                        )
                    )
                }
            }
            .padding()
            .background(cardBackground)
            .overlay(cardBorder)

        } else {
            VStack(
                alignment: .leading,
                spacing: 10
            ) {
                Label(
                    "No Active Monthly Campaign",
                    systemImage: "pause.circle"
                )
                .font(.headline)
                .foregroundColor(.white)

                Text(
                    "Without an active subscription, Brand Awareness declines by 1% when each month ends."
                )
                .font(.subheadline)
                .foregroundColor(
                    .white.opacity(0.65)
                )
            }
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .padding()
            .background(cardBackground)
            .overlay(cardBorder)
        }
    }

    @ViewBuilder
    private var latestResultCard:
        some View {

        if let campaign =
            gameViewModel.company
                .lastMarketingCampaign {

            VStack(
                alignment: .leading,
                spacing: 12
            ) {
                Label(
                    "Latest Marketing Result",
                    systemImage:
                        "chart.line.uptrend.xyaxis"
                )
                .font(.headline)
                .foregroundColor(.white)

                HStack {
                    VStack(
                        alignment: .leading,
                        spacing: 4
                    ) {
                        Text(campaign.name)
                            .font(
                                .subheadline.bold()
                            )
                            .foregroundColor(.white)

                        Text(
                            gameViewModel.company
                                .lastMarketingWasSubscription
                            ? "Monthly campaign"
                            : "One-time campaign"
                        )
                        .font(.caption)
                        .foregroundColor(
                            .white.opacity(0.6)
                        )
                    }

                    Spacer()

                    Text(
                        "+\(gameViewModel.company.lastMarketingGain)%"
                    )
                    .font(.title3.bold())
                    .foregroundColor(.green)
                }
            }
            .padding()
            .background(cardBackground)
            .overlay(cardBorder)
        }
    }

    private var informationCard: some View {
        VStack(
            alignment: .leading,
            spacing: 12
        ) {
            Label(
                "How Marketing Works",
                systemImage: "info.circle.fill"
            )
            .font(.headline)
            .foregroundColor(.white)

            informationRow(
                icon: "waveform.path.ecg",
                text:
                    "Results fluctuate because customer interest and market activity change each month."
            )

            informationRow(
                icon: "scope",
                text:
                    "Every possible result stays inside the displayed range, so the risk is visible before you invest."
            )

            informationRow(
                icon: "repeat",
                text:
                    "Only one monthly campaign can be active. Switching plans replaces the current subscription."
            )

            informationRow(
                icon: "creditcard.fill",
                text:
                    "Marketing investments can push the company into debt."
            )
        }
        .padding()
        .background(cardBackground)
        .overlay(cardBorder)
    }

    private func informationRow(
        icon: String,
        text: String
    ) -> some View {
        HStack(
            alignment: .top,
            spacing: 10
        ) {
            Image(systemName: icon)
                .foregroundColor(.green)
                .frame(width: 22)

            Text(text)
                .font(.subheadline)
                .foregroundColor(
                    .white.opacity(0.65)
                )
        }
    }

    private func campaignCard(
        _ campaign: MarketingCampaign
    ) -> some View {
        VStack(
            alignment: .leading,
            spacing: 16
        ) {
            HStack(spacing: 12) {
                Image(
                    systemName: campaign.iconName
                )
                .font(.title2)
                .foregroundColor(.orange)
                .frame(
                    width: 48,
                    height: 48
                )
                .background(
                    RoundedRectangle(
                        cornerRadius: 13
                    )
                    .fill(
                        Color.orange
                            .opacity(0.15)
                    )
                )

                VStack(
                    alignment: .leading,
                    spacing: 5
                ) {
                    Text(campaign.name)
                        .font(.title3.bold())
                        .foregroundColor(.white)

                    Text(campaign.riskLevel)
                        .font(.caption.bold())
                        .foregroundColor(
                            riskColor(
                                for: campaign
                            )
                        )
                }

                Spacer()
            }

            Text(campaign.description)
                .font(.subheadline)
                .foregroundColor(
                    .white.opacity(0.65)
                )

            darkDivider

            oneTimeSection(campaign)

            darkDivider

            monthlySection(campaign)

            darkDivider

            VStack(
                alignment: .leading,
                spacing: 6
            ) {
                Text("Risk and limitation")
                    .font(.subheadline.bold())
                    .foregroundColor(.white)

                Text(
                    campaign.riskExplanation
                )
                .font(.caption)
                .foregroundColor(
                    .white.opacity(0.6)
                )
            }
        }
        .padding()
        .background(cardBackground)
        .overlay(cardBorder)
    }

    private func oneTimeSection(
        _ campaign: MarketingCampaign
    ) -> some View {
        VStack(
            alignment: .leading,
            spacing: 11
        ) {
            Text("One-Time Campaign")
                .font(.headline)
                .foregroundColor(.white)

            detailRow(
                title: "Immediate cost",
                value:
                    currency(
                        campaign.oneTimeCost
                    )
            )

            detailRow(
                title:
                    "Possible awareness gain",
                value:
                    campaign.oneTimeGainRangeText
            )

            detailRow(
                title: "Commitment",
                value: "One payment"
            )

            primaryButton(
                title:
                    "Run One-Time Campaign"
            ) {
                selectedOneTimeCampaign =
                    campaign

                showingOneTimeConfirmation =
                    true
            }
        }
    }

    private func monthlySection(
        _ campaign: MarketingCampaign
    ) -> some View {
        let isActive =
            gameViewModel
                .isMarketingCampaignActive(
                    campaign
                )

        return VStack(
            alignment: .leading,
            spacing: 11
        ) {
            Text("Monthly Campaign")
                .font(.headline)
                .foregroundColor(.white)

            detailRow(
                title: "Recurring cost",
                value:
                    "\(currency(campaign.monthlyCost))/month"
            )

            detailRow(
                title:
                    "Possible monthly gain",
                value:
                    campaign
                        .monthlyGainRangeText
            )

            detailRow(
                title: "Commitment",
                value: "Cancel anytime"
            )

            Button {
                guard !isActive else {
                    return
                }

                selectedMonthlyCampaign =
                    campaign

                showingMonthlyConfirmation =
                    true
            } label: {
                Text(
                    monthlyButtonTitle(
                        for: campaign,
                        isActive: isActive
                    )
                )
                .fontWeight(.semibold)
                .foregroundColor(
                    isActive
                    ? .white.opacity(0.5)
                    : .black
                )
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(
                        cornerRadius: 12
                    )
                    .fill(
                        isActive
                        ? Color.white
                            .opacity(0.08)
                        : Color.green
                    )
                )
                .overlay(
                    RoundedRectangle(
                        cornerRadius: 12
                    )
                    .stroke(
                        isActive
                        ? Color.white
                            .opacity(0.15)
                        : Color.green,
                        lineWidth: 1
                    )
                )
            }
            .disabled(isActive)
        }
    }

    private func primaryButton(
        title: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(
                        cornerRadius: 12
                    )
                    .fill(Color.green)
                )
        }
    }

    private func detailRow(
        title: String,
        value: String
    ) -> some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(
                    .white.opacity(0.6)
                )

            Spacer()

            Text(value)
                .font(.subheadline.bold())
                .foregroundColor(.white)
                .multilineTextAlignment(
                    .trailing
                )
        }
    }

    private func subscriptionDetailRow(
        title: String,
        value: String
    ) -> some View {
        HStack(alignment: .top) {
            Text(title)
                .foregroundColor(
                    .white.opacity(0.6)
                )

            Spacer()

            Text(value)
                .foregroundColor(.white)
                .multilineTextAlignment(
                    .trailing
                )
        }
        .font(.subheadline)
    }

    private var darkDivider: some View {
        Rectangle()
            .fill(
                Color.white.opacity(0.12)
            )
            .frame(height: 1)
    }

    private var cardBackground: some View {
        RoundedRectangle(
            cornerRadius: 18
        )
        .fill(
            Color.white.opacity(0.09)
        )
    }

    private var cardBorder: some View {
        RoundedRectangle(
            cornerRadius: 18
        )
        .stroke(
            Color.white.opacity(0.12),
            lineWidth: 1
        )
    }

    private var oneTimeConfirmationTitle:
        String {

        guard let campaign =
            selectedOneTimeCampaign else {
            return "Run Campaign?"
        }

        return "Run \(campaign.name)?"
    }

    private var monthlyConfirmationTitle:
        String {

        guard let campaign =
            selectedMonthlyCampaign else {
            return "Start Monthly Campaign?"
        }

        if gameViewModel.company
            .activeMonthlyMarketingCampaign
            == nil {

            return "Start \(campaign.name)?"
        }

        return "Switch Marketing Plan?"
    }

    private func monthlyConfirmationButtonTitle(
        for campaign: MarketingCampaign
    ) -> String {
        if gameViewModel.company
            .activeMonthlyMarketingCampaign
            == nil {

            return "Start Monthly Campaign"
        }

        return "Switch to \(campaign.name)"
    }

    private func monthlyConfirmationMessage(
        for campaign: MarketingCampaign
    ) -> String {
        let campaignDetails =
            """
            Cost: \(currency(campaign.monthlyCost)) per month
            Expected result: \(campaign.monthlyGainRangeText)

            The campaign will be charged and applied when the month ends.
            """

        guard let currentCampaign =
            gameViewModel.company
                .activeMonthlyMarketingCampaign
        else {
            return campaignDetails
        }

        return """
        Your current \(currentCampaign.name) subscription will be replaced.

        \(campaignDetails)
        """
    }

    private func monthlyButtonTitle(
        for campaign: MarketingCampaign,
        isActive: Bool
    ) -> String {
        if isActive {
            return "Current Monthly Campaign"
        }

        if gameViewModel.company
            .activeMonthlyMarketingCampaign
            != nil {

            return "Switch to This Campaign"
        }

        return "Start Monthly Campaign"
    }

    private func runOneTimeCampaign(
        _ campaign: MarketingCampaign
    ) {
        let previousAwareness =
            gameViewModel.company
                .brandAwareness

        gameViewModel
            .runOneTimeMarketingCampaign(
                campaign
            )

        let actualGain =
            gameViewModel.company
                .brandAwareness -
            previousAwareness

        resultMessage =
            """
            \(campaign.name) increased Brand Awareness by \(actualGain)%.

            Brand Awareness is now \(gameViewModel.company.brandAwareness)%.
            """

        showingResult = true
    }

    private func activateMonthlyCampaign(
        _ campaign: MarketingCampaign
    ) {
        gameViewModel
            .startMonthlyMarketingCampaign(
                campaign
            )

        resultMessage =
            """
            \(campaign.name) is now your active monthly campaign.

            You will be charged \(currency(campaign.monthlyCost)) when the month ends, with an expected Brand Awareness gain of \(campaign.monthlyGainRangeText).
            """

        showingResult = true
    }

    private func cancelMonthlyCampaign() {
        let cancelledCampaign =
            gameViewModel.company
                .activeMonthlyMarketingCampaign

        gameViewModel
            .cancelMonthlyMarketingCampaign()

        if let cancelledCampaign =
            cancelledCampaign {

            resultMessage =
                """
                \(cancelledCampaign.name) was cancelled.

                No subscription cost will be charged at the next month end. Without another active campaign, Brand Awareness will decline by 1% per month.
                """

            showingResult = true
        }
    }

    private func riskColor(
        for campaign: MarketingCampaign
    ) -> Color {
        switch campaign {
        case .socialMedia:
            return .green

        case .paidAdvertising,
             .marketingAgency:
            return .orange
        }
    }

    private func currency(
        _ value: Double
    ) -> String {
        if value >= 1_000_000 {
            return String(
                format:
                    "$%.1fM",
                value / 1_000_000
            )
        }

        if value >= 1_000 {
            return String(
                format:
                    "$%.0fK",
                value / 1_000
            )
        }

        return "$\(Int(value))"
    }
}
