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
    
    private var lastRequestTime: Date?
    private let minimumRequestInterval: TimeInterval = 2.0
    
    private let cacheKey = "cachedActivities"
    private let cacheTimestampKey = "cacheTimestamp"
    private let cacheValidityDuration: TimeInterval = 3600
    
    private func canMakeRequest() -> Bool {
        guard let lastTime = lastRequestTime else {
            return true
        }
        let timeSinceLastRequest = Date().timeIntervalSince(lastTime)
        return timeSinceLastRequest >= minimumRequestInterval
    }
    
    private func cacheActivities(_ activities: [ActivityModel]) {
        if let encoded = try? JSONEncoder().encode(activities) {
            UserDefaults.standard.set(encoded, forKey: cacheKey)
            UserDefaults.standard.set(Date(), forKey: cacheTimestampKey)
        }
    }
    
    private func loadCachedActivities() -> [ActivityModel]? {
        guard let timestamp = UserDefaults.standard.object(forKey: cacheTimestampKey) as? Date,
              Date().timeIntervalSince(timestamp) < cacheValidityDuration,
              let data = UserDefaults.standard.data(forKey: cacheKey),
              let activities = try? JSONDecoder().decode([ActivityModel].self, from: data) else {
            return nil
        }
        return activities
    }
    
    func fetchAllActivities() {
        if let cachedActivities = loadCachedActivities() {
            print("📦 Using cached activities: \(cachedActivities.count)")
            DispatchQueue.main.async {
                self.models = cachedActivities
                cachedActivities.forEach { activity in
                    self.delegate?.onActivityDidUpdate(model: activity)
                }
            }
            return
        }
        
        if !canMakeRequest() {
            let timeRemaining = minimumRequestInterval - Date().timeIntervalSince(lastRequestTime!)
            DispatchQueue.main.async {
                self.delegate?.onActivityFetchFailed(error: "Please wait \(Int(ceil(timeRemaining))) seconds before trying again.")
            }
            return
        }
        
        lastRequestTime = Date()
        
        let urlString = "https://bored-api.appbrewery.com/filter"
        
        guard let url = URL(string: urlString) else {
            delegate?.onActivityFetchFailed(error: "Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.delegate?.onActivityFetchFailed(error: error.localizedDescription)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self?.delegate?.onActivityFetchFailed(error: "No data received")
                }
                return
            }
            
            do {
                let activities = try JSONDecoder().decode([ActivityModel].self, from: data)
                print("✅ Successfully decoded \(activities.count) activities")
                
                self?.cacheActivities(activities)
                
                DispatchQueue.main.async {
                    self?.models = activities
                    
                    activities.forEach { activity in
                        self?.delegate?.onActivityDidUpdate(model: activity)
                    }
                    
                    if activities.isEmpty {
                        self?.delegate?.onActivityFetchFailed(error: "No activities found")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self?.delegate?.onActivityFetchFailed(error: "Failed to load activities. Please try again later.")
                }
            }
        }.resume()
    }
    
    func fetchActivity(type: ActivityType?) {
        if let type = type {
            let urlString = "https://bored-api.appbrewery.com/filter?type=\(type.rawValue)"
            
            guard let url = URL(string: urlString) else {
                delegate?.onActivityFetchFailed(error: "Invalid URL")
                return
            }
            
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self?.delegate?.onActivityFetchFailed(error: error.localizedDescription)
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        self?.delegate?.onActivityFetchFailed(error: "No data received")
                    }
                    return
                }
                
                do {
                    let activities = try JSONDecoder().decode([ActivityModel].self, from: data)
                    
                    DispatchQueue.main.async {
                        activities.forEach { activity in
                            self?.delegate?.onActivityDidUpdate(model: activity)
                        }
                        
                        if activities.isEmpty {
                            self?.delegate?.onActivityFetchFailed(error: "No activities found for this type")
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self?.delegate?.onActivityFetchFailed(error: "Failed to load activities")
                    }
                }
            }.resume()
        } else {
            fetchAllActivities()
        }
    }
}
