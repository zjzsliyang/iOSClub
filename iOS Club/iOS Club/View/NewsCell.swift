//
//  NewsCell.swift
//  Student Club
//
//  Created by Yang Li on 2018/9/22.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit
import SnapKit
import BMPlayer
import SkeletonView
import LLCycleScrollView

class NewsCell: UITableViewCell {
    
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        for mediaView in self.subviews {
            if type(of: mediaView) == BMPlayer.self || type(of: mediaView) == LLCycleScrollView.self {
                mediaView.removeFromSuperview()
            }
        }
    }
    
    func setNews(news: News) {
        userButton.setTitle(news.user.username, for: .normal)
        timeLabel.text = news.time
        titleLabel.text = news.title
        contentTextView.text = news.content
        contentTextView.textContainer.maximumNumberOfLines = 3
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
            setupImages(images: news.images)
        }
    }
    
    func setupVideo(video: String) {
        BMPlayerConf.enableBrightnessGestures = false
        BMPlayerConf.enableVolumeGestures = false
        BMPlayerConf.shouldAutoPlay = false
        BMPlayerConf.topBarShowInCase = .none
        let videoplayer = BMPlayer()
        self.addSubview(videoplayer)
        videoplayer.gestureRecognizers?.removeAll()
        videoplayer.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(150)
            make.left.right.equalTo(self)
            make.height.equalTo(videoplayer.snp.width).multipliedBy(9.0/16.0).priority(750)
        }
        let asset = BMPlayerResource(url: URL(string: video)!)
        videoplayer.setVideo(resource: asset)
    }
    
    func setupImages(images: [String]) {
        let imagesplayer = LLCycleScrollView.llCycleScrollViewWithFrame(CGRect(x: 0, y: 150, width: self.frame.width, height: self.frame.width / 16 * 9))
        imagesplayer.autoScroll = true
        imagesplayer.infiniteLoop = true
        imagesplayer.imageViewContentMode = .scaleAspectFit
        self.addSubview(imagesplayer)
        DispatchQueue.main.async {
            imagesplayer.imagePaths = images
        }
    }

}
