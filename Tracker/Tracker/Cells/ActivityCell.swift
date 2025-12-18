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

    @IBOutlet weak var activityNameField: UILabel!
//    @IBOutlet weak var activityTypeField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    private var activity: ActivityModel?
    weak var delegate: ActivityCellDelegate?

    static let identifier = "ActivityCell"

    func configure(with activity: ActivityModel) {

        activityNameField.text = activity.activity
//        activityTypeField.text = activity.type
    }
    
    @IBAction func didTapAdd(_ sender: UIButton) {
        guard let activity = activity else { return }
        delegate?.didTapAddActivity(activity)
    }
}
