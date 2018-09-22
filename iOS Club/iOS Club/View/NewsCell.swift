//
//  NewsCell.swift
//  iOS Club
//
//  Created by Yang Li on 2018/9/22.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit
import BMPlayer
import SkeletonView

class NewsCell: UITableViewCell {
    
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    func setNews(news: News) {
        do {
            let avatarData = try Data(contentsOf: URL(string: news.user.avatar)!)
            avatarView.image = UIImage(data: avatarData)
        }
        catch {
            avatarView.image = UIImage(named: "avatar")
        }
        print(news.user.avatar)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
