//
//  NewsCell.swift
//  iOS Club
//
//  Created by Yang Li on 2018/9/22.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit
import SnapKit
import BMPlayer
import SkeletonView

class NewsCell: UITableViewCell {
    
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    let videoplayer = BMPlayer()
    
    func setNews(news: News) {
        userButton.setTitle(news.user.username, for: .normal)
        timeLabel.text = news.time
        titleLabel.text = news.title
        do {
            let avatarData = try Data(contentsOf: URL(string: news.user.avatar)!)
            avatarView.image = UIImage(data: avatarData)
        }
        catch {
            avatarView.image = UIImage(named: "avatar")
        }
        if news.video != "" {
            setupVideo(video: news.video!)
        } else if news.images != [] {
            setupImages()
        }
    }
    
    func setupVideo(video: String) {
        self.addSubview(videoplayer)
        videoplayer.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(150)
            make.left.right.equalTo(self)
            make.height.equalTo(videoplayer.snp.width).multipliedBy(9.0/16.0).priority(750)
        }
        let asset = BMPlayerResource(url: URL(string: video)!)
        videoplayer.setVideo(resource: asset)
    }
    
    func setupImages() {
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
