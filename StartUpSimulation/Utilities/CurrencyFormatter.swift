//
//  CurrencyFormatter.swift
//  StartUpSimulation
//
//  Created by Talya Benatar on 19/07/2026.
//

import Foundation

enum CurrencyFormatter {
    static func compact(
        _ amount: Double,
        showSign: Bool = false
    ) -> String {
        let sign: String

        if showSign {
            sign = amount >= 0 ? "+" : "-"
        } else {
            sign = amount < 0 ? "-" : ""
        }

        let absoluteAmount = abs(amount)

        if absoluteAmount >= 1_000_000_000 {
            return sign + String(
                format: "$%.2fB",
                absoluteAmount / 1_000_000_000
            )
        }

        if absoluteAmount >= 1_000_000 {
            return sign + String(
                format: "$%.2fM",
                absoluteAmount / 1_000_000
            )
        }

        if absoluteAmount >= 1_000 {
            return sign + String(
                format: "$%.1fK",
                absoluteAmount / 1_000
            )
        }

        return sign + String(
            format: "$%.0f",
            absoluteAmount
        )
    }

    static func exact(
        _ amount: Double,
        showSign: Bool = false
    ) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0

        let text = formatter.string(
            from: NSNumber(value: abs(amount))
        ) ?? "$0"

        if showSign {
            return amount >= 0
                ? "+\(text)"
                : "-\(text)"
        }

        return amount < 0
            ? "-\(text)"
            : text
    }
}
