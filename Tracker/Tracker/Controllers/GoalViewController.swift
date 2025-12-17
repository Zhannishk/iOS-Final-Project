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

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Goals"

        tableView.dataSource = self
        tableView.delegate = self
    }

    @IBAction func didTapAdd() {
        guard let vc = storyboard?.instantiateViewController(identifier: "addGoal") as? AddGoalViewController else {
            return
        }

        vc.completion = { title, accessibility, date, duration in
            let goal = GoalModel(
                title: title,
                accessibility: accessibility,
                date: date,
                duration: duration
            )

            self.goals.append(goal)

            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.navigationController?.popViewController(animated: true)
            }
        }

        navigationController?.pushViewController(vc, animated: true)
    }
}


extension GoalViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        goals.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "GoalTableViewCell",
            for: indexPath
        )

        let goal = goals[indexPath.row]
        cell.textLabel?.text = goal.title

        let hours = Int(goal.duration / 3600)
        let minutes = Int(goal.duration.truncatingRemainder(dividingBy: 3600) / 60)
        cell.detailTextLabel?.text = "⏱ \(hours)h \(minutes)m"

        return cell
    }
}

