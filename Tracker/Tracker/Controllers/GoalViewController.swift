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
        
        loadGoals()
    }

    @IBAction func didTapAdd() {
        guard let vc = storyboard?.instantiateViewController(identifier: "addGoal") as? AddGoalViewController else {
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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "GoalCell",
            for: indexPath
        )

        let goal = goals[indexPath.row]
        cell.textLabel?.text = goal.title
        cell.detailTextLabel?.text =
            "Accessibility: \(String(format: "%.2f", goal.accessibility))"

        return cell
    }
}

