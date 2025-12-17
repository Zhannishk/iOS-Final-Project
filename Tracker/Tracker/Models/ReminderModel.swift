//
//  ReminderModel.swift
//  
//
//  Created by Zhalgas Bagytzhan on 16.12.2025.
//

import Foundation

struct ReminderModel: Codable {
    let id: Int64
    let title: String
    let accessibility: Double
    let dateOfRemind: Date
}
