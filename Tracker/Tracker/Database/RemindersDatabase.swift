//
//  RemindersDatabase.swift
//  Tracker
//
//  Created by Zhalgas Bagytzhan on 17.12.2025.
//
import Foundation
import SQLite

final class RemindersDatabase {

    static let shared = RemindersDatabase()

    private let db: Connection

    private let reminders = Table("reminders")

    private let id = Expression<Int64>("id")
    private let title = Expression<String>("title")
    private let accessibility = Expression<Double>("accessibility")
    private let dateOfRemind = Expression<Double>("date")

    private init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!

        db = try! Connection("\(path)/reminders.db")
        createTable()
    }

    private func createTable() {
        do {
            try db.run(reminders.create(ifNotExists: true) { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(title)
                t.column(accessibility)
                t.column(dateOfRemind)
            })
        } catch {
            print("Table creation error:", error)
        }
    }

    func insertReminder(
        title: String,
        accessibility: Double,
        dateOfRemind: Date
    ) {
        let insert = reminders.insert(
            self.title <- title,
            self.accessibility <- accessibility,
            self.dateOfRemind <- date.timeIntervalSince1970,
        )

        do {
            try db.run(insert)
        } catch {
            print("Insert error:", error)
        }
    }
    
    func fetchReminders() -> [ReminderModel] {
        var result: [ReminderModel] = []

        do {
            for reminder in try db.prepare(reminders) {
                result.append(
                    ReminderModel(
                        id: reminder[id],
                        title: reminder[title],
                        accessibility: reminder[accessibility],
                        dateOfRemind: Date(timeIntervalSince1970: reminder[dateOfRemind]),
                    )
                )
            }
        } catch {
            print("Fetch error:", error)
        }

        return result
    }
    
    func updateReminder(_ reminder: ReminderModel) {
        let item = reminders.filter(id == reminder.id)

        do {
            try db.run(item.update(
                title <- reminder.title,
                accessibility <- reminder.accessibility,
                startDate <- reminder.dateOfRemind.timeIntervalSince1970
            ))
        } catch {
            print("Update error:", error)
        }
    }
    
    func deleteReminder(id goalId: Int64) {
        let item = reminders.filter(id == goalId)

        do {
            try db.run(item.delete())
        } catch {
            print("Delete error:", error)
        }
    }
}
