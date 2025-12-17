//
//  AddReminderViewController.swift
//  Tracker
//
//  Created by Zhalgas Bagytzhan on 17.12.2025.
//

import UIKit

class AddReminderViewController: UIViewController {
    
    @IBOutlet var reminderTitleField: UITextField!
    @IBOutlet weak var reminderAccessibilitySlider: UISlider!
    @IBOutlet weak var reminderAccessibilityLabel: UILabel!
    @IBOutlet var reminderDatePicker: UIDatePicker!

    public var completion: ((String, Double, Date) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Reminder"

        configureUI()
    }
    
    private func configureUI() {
        reminderAccessibilitySlider.minimumValue = 0
        reminderAccessibilitySlider.maximumValue = 1
        reminderAccessibilitySlider.value = 0.5

        reminderAccessibilityLabel.text = String(format: "%.2f", reminderAccessibilitySlider.value)

    }

    @IBAction func accessibilityChanged(_ sender: UISlider) {
        reminderAccessibilityLabel.text = String(format: "%.2f", sender.value)
    }

    @IBAction func didTapSave() {
        let title = reminderTitleField.text?.trimmingCharacters(in: .whitespacesAndNewlines)

        guard let title, !title.isEmpty else {
            return
        }

        completion?(
            title,
            Double(reminderAccessibilitySlider.value),
            reminderDatePicker.date
        )

        navigationController?.popViewController(animated: true)
    }

    @IBAction func didTapCancel() {
        navigationController?.popViewController(animated: true)
    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
