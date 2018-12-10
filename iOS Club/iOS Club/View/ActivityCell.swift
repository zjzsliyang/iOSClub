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
    @IBOutlet weak var timeLabel: UILabel!
    
    func setActivity(title: String?, location: String?, time: Date?) {
        titleLabel.text = title
        locationLabel.text = location        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.dateFormat = "MM-dd HH:mm"
        if time != nil {
            timeLabel.text = dateFormatter.string(from: time!)
        }
    }
    
}
