//
//  GoalCell.swift
//  Tracker
//
//  Created by Zhalgas Bagytzhan on 17.12.2025.
//

import UIKit

class GoalCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!

    static let identifier = "GoalCell"

    func configure(with goal: GoalModel) {
        titleLabel.text = goal.title

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        startDateLabel.text = "Start: \(formatter.string(from: goal.startDate))"

        let hours = Int(goal.duration / 3600)
        durationLabel.text = "Duration: \(hours) hour(s)"
    }
}
