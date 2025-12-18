//
//  ReminderViewController.swift
//  
//
//  Created by Zhalgas Bagytzhan on 16.12.2025.
//

import UIKit
import UserNotifications

class ReminderViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var goals: [GoalModel] = []
    private var reminders: [ReminderModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Reminders"

        tableView.dataSource = self
        tableView.delegate = self
        
        loadReminders()
    }

    @IBAction func didTapAdd() {
        guard let vc = storyboard?.instantiateViewController(identifier: "manageReminder") as? ManageReminderViewController else {
            return
        }

        vc.completion = { title, accessibility, date in
            DispatchQueue.main.async {
                self.loadReminders()
            }
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadReminders()
    }
    
    private func loadGoals() {
        goals = GoalsDatabase.shared.fetchGoals()
        tableView.reloadData()
    }

    private func loadReminders() {
        reminders = RemindersDatabase.shared.fetchReminders()
        reminders.forEach {
            scheduleNotification($0)
        }
        
        tableView.reloadData()
    }
}

extension ReminderViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let reminder = reminders[indexPath.row]
            RemindersDatabase.shared.deleteReminder(id: reminder.id)

            reminders.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reminders.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ReminderCell.identifier,
            for: indexPath
        ) as? ReminderCell else {
            return UITableViewCell()
        }

        let reminder = reminders[indexPath.row]
        cell.configure(with: reminder)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            
        guard let vc = storyboard?.instantiateViewController(identifier: "manageReminder") as? ManageReminderViewController else {
            return
        }
        
        vc.reminderToEdit = reminders[indexPath.row]
        vc.completion = { _, _, _ in
            self.loadReminders()
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ReminderViewController {

    private func scheduleNotification(_ reminder: ReminderModel) {

        let content = UNMutableNotificationContent()
        content.title = reminder.title
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents(
                [.year, .month, .day, .hour, .minute],
                from: reminder.dateOfRemind
            ),
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: "reminder_\(reminder.id)",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }
}

extension ReminderViewController: ActivitySelectionDelegate {
    func didSelectActivity(_ activity: ActivityModel, type: ActivityAddType) {
        switch type {
        case .goal:
            let newGoal = GoalModel(
                id: Int64(Date().timeIntervalSince1970),
                title: activity.activityName,
                startDate: Date(),
                duration: 3600
            )
            GoalsDatabase.shared.insertGoal(
                title: newGoal.title,
                startDate: newGoal.startDate,
                duration: newGoal.duration
            )
            
        case .reminder:
            let newReminder = ReminderModel(
                id: Int64(Date().timeIntervalSince1970),
                title: activity.activityName,
                accessibility: activity.accessibility,
                dateOfRemind: Date()
            )
            RemindersDatabase.shared.insertReminder(reminder: newReminder)
            loadReminders()
        }
    }
}
