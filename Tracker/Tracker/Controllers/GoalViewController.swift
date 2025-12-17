//
//  GoalViewController.swift
//  
//
//  Created by Zhalgas Bagytzhan on 16.12.2025.
//

import UIKit

class GoalViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private var goals: [GoalModel] = []
    private var reminders: [ReminderModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Goals"

        tableView.dataSource = self
        tableView.delegate = self
        
        loadGoals()
    }

    @IBAction func didTapAdd() {
        guard let vc = storyboard?.instantiateViewController(identifier: "manageGoal") as? ManageGoalViewController else {
            return
        }

        vc.completion = { _, _, _, _ in
            self.loadGoals()
        }

        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadGoals()
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


extension GoalViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let goal = goals[indexPath.row]
            GoalsDatabase.shared.deleteGoal(id: goal.id)

            goals.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        goals.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: GoalCell.identifier,
            for: indexPath
        ) as? GoalCell else {
            return UITableViewCell()
        }

        let goal = goals[indexPath.row]
        cell.configure(with: goal)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let vc = storyboard?.instantiateViewController(identifier: "manageGoal") as? ManageGoalViewController else {
            return
        }
        
        vc.goalToEdit = goals[indexPath.row]
        vc.completion = { _, _, _, _ in
            self.loadGoals()
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension GoalViewController: ActivitySelectionDelegate {
    func didSelectActivity(_ activity: ActivityModel, type: ActivityAddType) {
        switch type {
        case .goal:
            let newGoal = GoalModel(
                id: Int64(Date().timeIntervalSince1970),
                title: activity.activityName,
                accessibility: activity.accessibility,
                startDate: Date(),
                duration: 3600
            )
            GoalsDatabase.shared.insertGoal(
                title: newGoal.title,
                accessibility: newGoal.accessibility,
                startDate: newGoal.startDate,
                duration: newGoal.duration
            )
            loadGoals()

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
