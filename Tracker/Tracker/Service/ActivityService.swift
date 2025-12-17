//
//  ActivityService.swift
//  
//
//  Created by Zhalgas Bagytzhan on 17.12.2025.
//

import Foundation

protocol ActivityServiceDelegate: AnyObject {
    func onActivityDidUpdate(model: ActivityModel)
    func onActivityFetchFailed(error: String)
}

class ActivityService {
    var models = [ActivityModel]()
    weak var delegate: ActivityServiceDelegate?
    
    func fetchActivity(type: ActivityType?) {
        var urlString = "https://bored-api.appbrewery.com/filter"
        if let type = type {
            urlString += "?type=\(type.rawValue)"
        }
        guard let url = URL(string: urlString) else {
            delegate?.onActivityFetchFailed(error: "Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.delegate?.onActivityFetchFailed(error: error.localizedDescription)
                }
                return
            }
            
            guard let data = data,
                  let activity = try? JSONDecoder().decode(ActivityModel.self, from: data) else {
                DispatchQueue.main.async {
                    self?.delegate?.onActivityFetchFailed(error: "Failed to decode data")
                }
                return
            }
            
            DispatchQueue.main.async {
                self?.delegate?.onActivityDidUpdate(model: activity)
            }
        }.resume()
    }
}
