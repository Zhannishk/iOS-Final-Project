//
//  GoalCell.swift
//  Tracker
//
//  Created by Zhalgas Bagytzhan on 17.12.2025.
//

import UIKit

class GoalCell: UITableViewCell {

    @IBOutlet weak var goalTitleField: UITextField!
    @IBOutlet weak var goalAccessibilitySlider: UISlider!
    @IBOutlet weak var goalAccessibilityLabel: UILabel!
    @IBOutlet weak var goalStartDatePicker: UIDatePicker!
    @IBOutlet weak var goalDurationPicker: UIDatePicker!

    static let identifier = "GoalCell"

    func configure(with goal: GoalModel) {

        goalTitleField.text = goal.title

        goalAccessibilitySlider.value = Float(goal.accessibility)
        goalAccessibilityLabel.text = String(format: "%.2f", goal.accessibility)

        goalStartDatePicker.date = goal.startDate

        goalDurationPicker.datePickerMode = .countDownTimer
        goalDurationPicker.countDownDuration = goal.duration
    }
}
