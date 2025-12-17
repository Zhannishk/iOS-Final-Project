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

    private var reminders: [ReminderModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Reminders"

        tableView.dataSource = self
        tableView.delegate = self
        
        loadReminders()
    }

    @IBAction func didTapAdd() {
        guard let vc = storyboard?.instantiateViewController(identifier: "addReminder") as? AddReminderViewController else {
            return
        }

        vc.completion = { title, accessibility, date in
            RemindersDatabase.shared.insertReminder(
                title: title,
                accessibility: accessibility,
                dateOfRemind: date
            )

            DispatchQueue.main.async {
                self.loadReminders()
                self.navigationController?.popViewController(animated: true)
            }
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadReminders()
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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ReminderCell",
            for: indexPath
        )

        let reminder = reminders[indexPath.row]
        cell.textLabel?.text = reminder.title
        cell.detailTextLabel?.text =
            "Accessibility: \(String(format: "%.2f", reminder.accessibility))"

        return cell
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
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }
}
