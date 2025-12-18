//
//  GoalModel.swift
//  
//
//  Created by Zhalgas Bagytzhan on 16.12.2025.
//

import Foundation

struct GoalModel: Codable {
    let id: Int64
    let title: String
    let startDate: Date
    let duration: TimeInterval
}
