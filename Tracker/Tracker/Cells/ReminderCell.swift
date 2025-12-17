//
//  ReminderTableViewCell.swift
//  Tracker
//
//  Created by Zhaniya Utemuratova on 17.12.2025.
//

import UIKit

class ReminderCell: UITableViewCell {

    @IBOutlet weak var reminderTitleField: UILabel!
    @IBOutlet weak var reminderDatePicker: UIDatePicker!

    static let identifier = "ReminderCell"

    func configure(with reminder: ReminderModel) {

        reminderTitleField.text = reminder.title

        reminderDatePicker.date = reminder.dateOfRemind

    }
}
