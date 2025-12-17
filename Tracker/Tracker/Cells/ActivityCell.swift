//
//  ActivityCell.swift
//  Tracker
//
//  Created by Zhalgas Bagytzhan on 18.12.2025.
//

import UIKit

protocol ActivityCellDelegate: AnyObject {
    func didTapAddActivity(_ activity: ActivityModel)
}
class ActivityCell: UITableViewCell {

    @IBOutlet weak var activityNameField: UITextField!
    @IBOutlet weak var activityTypeField: UITextField!
    @IBOutlet weak var activityAccessibilitySlider: UISlider!
    @IBOutlet weak var activityAccessibilityLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    private var activity: ActivityModel?
    weak var delegate: ActivityCellDelegate?

    static let identifier = "ActivityCell"

    func configure(with activity: ActivityModel) {

        activityNameField.text = activity.activityName
        activityTypeField.text = activity.type

        activityAccessibilitySlider.value = Float(activity.accessibility)
        activityAccessibilityLabel.text = String(format: "%.2f", activity.accessibility)
    }
    
    @IBAction func didTapAdd(_ sender: UIButton) {
        guard let activity = activity else { return }
        delegate?.didTapAddActivity(activity)
    }
}
