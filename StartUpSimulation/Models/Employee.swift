//
//  Employee.swift
//  StartUpSimulation
//
//  Created by Talya Benatar on 15/07/2026.
//

import Foundation

struct Employee: Identifiable, Codable, Equatable {
    let id: UUID

    var name: String
    var role: EmployeeRole
    var seniority: EmployeeSeniority

    var monthlySalary: Double
    var hiringCost: Double

    var trait: String
    var personalNote: String

    var productivity: Int
    var moraleImpact: Int

    var hiredMonth: Int

    var severanceCost: Double {
        monthlySalary * 0.5
    }

    var productContribution: Double {
        Double(productivity) * role.productContributionMultiplier
    }

    var revenueContribution: Double {
        Double(productivity) * role.revenueContributionMultiplier
    }

    var marketValueContribution: Double {
        Double(productivity) * role.marketValueContributionMultiplier
    }

    init(
        id: UUID = UUID(),
        name: String,
        role: EmployeeRole,
        seniority: EmployeeSeniority,
        monthlySalary: Double,
        hiringCost: Double,
        trait: String,
        personalNote: String,
        productivity: Int,
        moraleImpact: Int,
        hiredMonth: Int = 0
    ) {
        self.id = id
        self.name = name
        self.role = role
        self.seniority = seniority
        self.monthlySalary = monthlySalary
        self.hiringCost = hiringCost
        self.trait = trait
        self.personalNote = personalNote
        self.productivity = productivity
        self.moraleImpact = moraleImpact
        self.hiredMonth = hiredMonth
    }
}
