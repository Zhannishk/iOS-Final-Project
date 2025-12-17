//
//  TaskModel.swift
//  
//
//  Created by Zhalgas Bagytzhan on 16.12.2025.
//


struct ActivityModel: Codable {
    let activityName: String
    let type: String
    let participants: Int
    let price: Double
    let link: String
    let key: String
    let accessibility: Double
    
    enum CodingKeys: String, CodingKey {
        case activityName = "activity"
        case type
        case participants
        case price
        case link
        case key
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
