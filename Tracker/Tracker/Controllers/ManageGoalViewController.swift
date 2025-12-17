//
//  AddGoalViewController.swift
//  Tracker
//
//  Created by Zhalgas Bagytzhan on 17.12.2025.
//

import UIKit

class AddGoalViewController: UIViewController {

    @IBOutlet weak var goalTitleField: UITextField!
    @IBOutlet weak var goalAccessibilitySlider: UISlider!
    @IBOutlet weak var goalAccessibilityLabel: UILabel!
    @IBOutlet weak var goalStartDatePicker: UIDatePicker!
    @IBOutlet weak var goalDurationPicker: UIDatePicker!

    var goalToEdit: GoalModel?
    var completion: ((String, Double, Date, TimeInterval) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Goal"
        
        if let goal = goalToEdit {
            title = "Edit Goal"
            goalTitleField.text = goal.title
            goalAccessibilitySlider.value = Float(goal.accessibility)
            goalStartDatePicker.date = goal.startDate
            goalDurationPicker.countDownDuration = goal.duration
        }

        configureUI()
        
    }

    private func configureUI() {
        goalAccessibilitySlider.minimumValue = 0
        goalAccessibilitySlider.maximumValue = 1
        goalAccessibilitySlider.value = 0.5

        goalAccessibilityLabel.text = String(format: "%.2f", goalAccessibilitySlider.value)

        goalDurationPicker.datePickerMode = .countDownTimer
        goalDurationPicker.countDownDuration = 3600

        goalDurationPicker.minimumDate = Date()
    }

    @IBAction func accessibilityChanged(_ sender: UISlider) {
        goalAccessibilityLabel.text = String(format: "%.2f", sender.value)
    }

    @IBAction func didTapSave() {
        let title = goalTitleField.text?.trimmingCharacters(in: .whitespacesAndNewlines)

        guard let title, !title.isEmpty else {
            showAlert()
            return
        }
        
        GoalsDatabase.shared.insertGoal(
            title: title,
            accessibility: Double(goalAccessibilitySlider.value),
            startDate: goalStartDatePicker.date,
            duration: goalDurationPicker.countDownDuration
        )
        
        if let goal = goalToEdit {
            let updatedGoal = GoalModel(
                id: goal.id,
                title: title,
                accessibility: Double(goalAccessibilitySlider.value),
                startDate: goalStartDatePicker.date,
                duration: goalDurationPicker.countDownDuration
            )
            GoalsDatabase.shared.updateGoal(updatedGoal)
        } else {
            GoalsDatabase.shared.insertGoal(
                title: title,
                accessibility: Double(goalAccessibilitySlider.value),
                startDate: goalStartDatePicker.date,
                duration: goalDurationPicker.countDownDuration
            )
        }

        completion?(
            title,
            Double(goalAccessibilitySlider.value),
            goalStartDatePicker.date,
            goalDurationPicker.countDownDuration
        )

        navigationController?.popViewController(animated: true)
    }

    @IBAction func didTapCancel() {
        navigationController?.popViewController(animated: true)
    }

    private func showAlert() {
        let alert = UIAlertController(
            title: "Error",
            message: "Please enter goal title",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func copyDatabaseIfNeeded(sourcePath: String) -> Bool {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let destinationPath = documents + "/goals.db"
        let exists = FileManager.default.fileExists(atPath: destinationPath)
        guard !exists else { return false }
        do {
            try FileManager.default.copyItem(atPath: sourcePath, toPath: destinationPath)
            return true
        } catch {
          print("error during file copy: \(error)")
            return false
        }
    }
}

