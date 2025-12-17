//
//  GoalsDatabase.swift
//  Tracker
//
//  Created by Zhalgas Bagytzhan on 17.12.2025.
//

import Foundation
import SQLite

final class GoalsDatabase {

    static let shared = GoalsDatabase()

    private let db: Connection

    private let goals = Table("goals")

    private let id = Expression<Int64>("id")
    private let title = Expression<String>("title")
    private let accessibility = Expression<Double>("accessibility")
    private let startDate = Expression<Double>("start_date")
    private let duration = Expression<Double>("duration")

    private init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!

        db = try! Connection("\(path)/goals.db")
        createTable()
    }

    private func createTable() {
        do {
            try db.run(goals.create(ifNotExists: true) { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(title)
                t.column(accessibility)
                t.column(startDate)
                t.column(duration)
            })
        } catch {
            print("Table creation error:", error)
        }
    }

    func insertGoal(
        title: String,
        accessibility: Double,
        startDate: Date,
        duration: TimeInterval
    ) {
        let insert = goals.insert(
            self.title <- title,
            self.accessibility <- accessibility,
            self.startDate <- startDate.timeIntervalSince1970,
            self.duration <- duration
        )

        do {
            try db.run(insert)
        } catch {
            print("Insert error:", error)
        }
    }
    
    func insertGoal(goal: GoalModel) {
        insertGoal(
            title: goal.title,
            accessibility: goal.accessibility,
            startDate: goal.startDate,
            duration: goal.duration
        )
    }
    
    func fetchGoals() -> [GoalModel] {
        var result: [GoalModel] = []

        do {
            for goal in try db.prepare(goals) {
                let model = GoalModel(
                    id: goal[id],
                    title: goal[title],
                    accessibility: goal[accessibility],
                    startDate: Date(timeIntervalSince1970: goal[startDate]),
                    duration: goal[duration]
                )
                result.append(model)
            }
        } catch {
            print("Fetch error:", error)
        }

        return result
    }
    
    func updateGoal(_ goal: GoalModel) {
        let item = goals.filter(id == goal.id)

        do {
            try db.run(item.update(
                title <- goal.title,
                accessibility <- goal.accessibility,
                startDate <- goal.startDate.timeIntervalSince1970,
                duration <- goal.duration
            ))
        } catch {
            print("Update error:", error)
        }
    }
    
    func deleteGoal(id: Int64) {
        let goalToDelete = goals.filter(self.id == id)

        do {
            try db.run(goalToDelete.delete())
        } catch {
            print("Delete error:", error)
        }
    }

}
