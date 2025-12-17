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
    
    var reminderToEdit: ReminderModel?
    public var completion: ((String, Double, Date) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Reminder"

        if let reminder = reminderToEdit {
            title = "Edit Reminder"
            reminderTitleField.text = reminder.title
            reminderAccessibilitySlider.value = Float(reminder.accessibility)
            reminderDatePicker.date = reminder.dateOfRemind
        }

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
        
        RemindersDatabase.shared.insertReminder(
            title: title,
            accessibility: Double(reminderAccessibilitySlider.value),
            dateOfRemind: reminderDatePicker.date,
        )
        
        if let reminder = reminderToEdit {
            let updatedReminder = ReminderModel(
                id: reminder.id,
                title: title,
                accessibility: Double(reminderAccessibilitySlider.value),
                dateOfRemind: reminderDatePicker.date
            )
            RemindersDatabase.shared.updateReminder(updatedReminder)
        } else {
            RemindersDatabase.shared.insertReminder(
                title: title,
                accessibility: Double(reminderAccessibilitySlider.value),
                dateOfRemind: reminderDatePicker.date
            )
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
