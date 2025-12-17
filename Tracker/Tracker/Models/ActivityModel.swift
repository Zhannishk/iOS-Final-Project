//
//  TaskModel.swift
//  
//
//  Created by Zhalgas Bagytzhan on 16.12.2025.
//

import Foundation

struct ActivityModel: Codable {
    let activityName: String
    let type: String
    let accessibility: Double
    
    enum CodingKeys: String, CodingKey {
        case activityName = "activity"
        case type
        case accessibility
    }
}

enum ActivityType: String, Codable {
    case education
    case recreational
    case social
    case charity
    case cooking
    case relaxation
    case busywork
}
