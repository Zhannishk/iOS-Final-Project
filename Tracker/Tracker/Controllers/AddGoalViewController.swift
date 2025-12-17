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


    var completion: ((String, Double, Date, TimeInterval) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Goal"

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
}

