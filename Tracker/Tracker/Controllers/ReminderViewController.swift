//
//  ReminderViewController.swift
//  
//
//  Created by Zhalgas Bagytzhan on 16.12.2025.
//

import UIKit

class ReminderViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
//        tableView.delegate = self
    }
    
    @IBAction func addTapped(_ sender: UIButton) {
        openAddActivity(type: .reminder)
    }

    func openAddActivity(type: ActivityType) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navVC = storyboard.instantiateViewController(
            withIdentifier: "AddActivityNavController"
        ) as! UINavigationController

        let addVC = navVC.topViewController as! AddActivityViewController
        addVC.activityType = type

        present(navVC, animated: true)
    }

    
}
extension ReminderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ReminderCell",
            for: indexPath
        ) as! ReminderTableViewCell

        cell.titleLabel.text = "Event #\(indexPath.row + 1)"
        cell.dateLabel.text = "24 Dec 2025"
        cell.selectionStyle = .none
        return cell

    }
}

