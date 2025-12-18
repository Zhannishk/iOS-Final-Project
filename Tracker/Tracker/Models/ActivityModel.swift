//
//  ActivityModel.swift
//  Tracker
//
//  Created by Zhalgas Bagytzhan on 17.12.2025.
//

import Foundation

enum ActivityType: String, CaseIterable, Codable {
    case education
    case recreational
    case social
    case diy
    case charity
    case cooking
    case relaxation
    case music
    case busywork
}

struct ActivityModel: Codable {
    let activity: String
    let availability: Double
    let type: String
    let participants: Int
    let price: Double
    let accessibility: String
    let duration: String
    let kidFriendly: Bool
    let link: String
    let key: String
    var activityName: String {
        return activity
    }
    
    var accessibilityValue: Double {
        switch accessibility.lowercased() {
        case let str where str.contains("few to no"):
            return 0.1
        case let str where str.contains("minor"):
            return 0.3
        case let str where str.contains("major"):
            return 0.7
        default:
            return 0.5
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case activity
        case availability
        case type
        case participants
        case price
        case accessibility
        case duration
        case kidFriendly
        case link
        case key
    }
}
