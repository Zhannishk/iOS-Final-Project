//
//  ReminderTableViewCell.swift
//  Tracker
//
//  Created by Zhaniya Utemuratova on 17.12.2025.
//

import UIKit

class ReminderCell: UITableViewCell {

    @IBOutlet weak var reminderTitleField: UITextField!
    @IBOutlet weak var reminderAccessibilitySlider: UISlider!
    @IBOutlet weak var reminderAccessibilityLabel: UILabel!
    @IBOutlet weak var reminderDatePicker: UIDatePicker!

    static let identifier = "ReminderCell"

    func configure(with reminder: ReminderModel) {

        reminderTitleField.text = reminder.title

        reminderAccessibilitySlider.value = Float(reminder.accessibility)
        reminderAccessibilityLabel.text = String(format: "%.2f", reminder.accessibility)

        reminderDatePicker.date = reminder.dateOfRemind

    }
}
