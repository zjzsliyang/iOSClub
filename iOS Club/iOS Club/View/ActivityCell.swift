//
//  ActivityCell.swift
//  Student Club
//
//  Created by Yang Li on 2018/9/23.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit

class ActivityCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    
    func setActivity(title: String?, location: String?, startTime: Date?, endTime: Date?) {
        titleLabel.text = title
        locationLabel.text = location
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.dateFormat = "HH:mm"
        if startTime != nil {
            startLabel.text = dateFormatter.string(from: startTime!)
        }
        if endTime != nil {
            endLabel.text = dateFormatter.string(from: endTime!)
        }
    }
    
}
