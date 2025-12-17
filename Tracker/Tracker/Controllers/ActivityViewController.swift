//
//  ActivityViewController.swift
//
//
//  Created by Zhalgas Bagytzhan on 16.12.2025.
//

import UIKit

enum ActivityAddType {
    case goal, reminder
}

protocol ActivitySelectionDelegate: AnyObject {
    func didSelectActivity(_ activity: ActivityModel, type: ActivityAddType)
}

class ActivityViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var activities: [ActivityModel] = []
    private let service = ActivityService()
    
    // ДОБАВЛЕНО: делегат для обратной связи
    weak var delegate: ActivitySelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Activities"

        tableView.dataSource = self
        tableView.delegate = self
        
        service.delegate = self
        service.fetchActivity(type: nil)
    }
    
    @IBAction func didTapAddActivity() {
        
        let alert = UIAlertController(
            title: "Add Activity",
            message: "This feature is under development",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension ActivityViewController: ActivityServiceDelegate {

    func onActivityDidUpdate(model: ActivityModel) {
        activities.insert(model, at: 0)
        tableView.reloadData()
    }

    func onActivityFetchFailed(error: String) {
        let alert = UIAlertController(
            title: "Error",
            message: error,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension ActivityViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        activities.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ActivityCell.identifier,
            for: indexPath
        ) as? ActivityCell else {
            return UITableViewCell()
        }

        let activity = activities[indexPath.row]
        cell.configure(with: activity)
        // ДОБАВЛЕНО: установка делегата для ячейки
        cell.delegate = self

        return cell
    }
}

extension ActivityViewController: ActivityCellDelegate {
    func didTapAddActivity(_ activity: ActivityModel) {
        let alert = UIAlertController(
            title: "Add Activity",
            message: "Choose where to add",
            preferredStyle: .actionSheet
        )
        
        alert.addAction(UIAlertAction(title: "Add to Goals", style: .default) { [weak self] _ in
            self?.delegate?.didSelectActivity(activity, type: .goal)
            self?.navigationController?.popViewController(animated: true)
        })
        
        alert.addAction(UIAlertAction(title: "Add to Reminders", style: .default) { [weak self] _ in
            self?.delegate?.didSelectActivity(activity, type: .reminder)
            self?.navigationController?.popViewController(animated: true)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
}
