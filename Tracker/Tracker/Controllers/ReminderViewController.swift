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
    }

    @IBAction func didTapAdd() {
        guard let vc = storyboard?.instantiateViewController(identifier: "addReminder") as? AddReminderViewController else {
            return
        }

        vc.completion = { title, accessibility, date in
            let reminder = ReminderModel(
                title: title,
                accessibility: accessibility,
                dateOfRemind: date
            )

            self.reminders.append(reminder)
            self.scheduleNotification(reminder)

            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.navigationController?.popViewController(animated: true)
            }
        }

        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ReminderViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reminders.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ReminderTableViewCell",
            for: indexPath
        )

        cell.textLabel?.text = reminders[indexPath.row].title
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
