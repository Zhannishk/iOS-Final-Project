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
    private var activityIndicator: UIActivityIndicatorView!
    
    // ДОБАВЛЕНО: делегат для обратной связи
    weak var delegate: ActivitySelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Activities"

        tableView.dataSource = self
        tableView.delegate = self
        
        setupActivityIndicator()
        
        service.delegate = self
        
        // Показываем индикатор загрузки
        activityIndicator.startAnimating()
        
        // Загружаем все активности (около 50+)
        service.fetchAllActivities()
    }
    
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    @IBAction func didTapAddActivity() {
        // ИСПРАВЛЕНО: это создает новый ActivityViewController, но нужен другой контроллер
        // Если есть контроллер для добавления активности, используйте его
        // Пока оставлю как placeholder
        
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
        activityIndicator.stopAnimating()
    }

    func onActivityFetchFailed(error: String) {
        activityIndicator.stopAnimating()
        
        let alert = UIAlertController(
            title: "Error",
            message: error,
            preferredStyle: .alert
        )
        
        if error.contains("Too many requests") || error.contains("wait") {
            alert.addAction(UIAlertAction(title: "Retry in 5s", style: .default) { [weak self] _ in
                // Автоматическая повторная попытка через 5 секунд
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    self?.activityIndicator.startAnimating()
                    self?.service.fetchAllActivities()
                }
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        } else {
            alert.addAction(UIAlertAction(title: "Retry Now", style: .default) { [weak self] _ in
                self?.activityIndicator.startAnimating()
                self?.service.fetchAllActivities()
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        }
        
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
