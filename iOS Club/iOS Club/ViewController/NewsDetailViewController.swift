//
//  NewsDetailViewController.swift
//  Student Club
//
//  Created by Yang Li on 2018/12/7.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit
import SnapKit
import BMPlayer
import SkeletonView
import SKPhotoBrowser
import LLCycleScrollView

class NewsDetailViewController: UIViewController {

    var news: News?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        setNews(news: news!)
    }

    func setNews(news: News) {
        userButton.setTitle(news.user.username, for: .normal)
        timeLabel.text = news.time
        titleLabel.text = news.title
        contentTextView.text = news.content
        contentTextView.translatesAutoresizingMaskIntoConstraints = true
        contentTextView.sizeToFit()
        contentTextView.isScrollEnabled = false
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
        self.view.addSubview(videoplayer)
        videoplayer.snp.makeConstraints { (make) in
            make.top.equalTo(contentTextView.frame.maxY)
            make.left.right.equalTo(self.view)
            make.height.equalTo(videoplayer.snp.width).multipliedBy(9.0/16.0).priority(750)
        }
        let asset = BMPlayerResource(url: URL(string: video)!)
        videoplayer.setVideo(resource: asset)
    }
    
    func setupImages(images: [String]) {
        let imagesplayer = LLCycleScrollView.llCycleScrollViewWithFrame(CGRect(x: 0, y: contentTextView.frame.maxY, width: self.view.frame.width, height: self.view.frame.width / 16 * 9))
        imagesplayer.autoScroll = true
        imagesplayer.infiniteLoop = true
        imagesplayer.imageViewContentMode = .scaleAspectFit
        imagesplayer.lldidSelectItemAtIndex = { index in
            self.detailImages(images: images, index: index)
        }
        self.view.addSubview(imagesplayer)
        DispatchQueue.main.async {
            imagesplayer.imagePaths = images
        }
    }
    
    func detailImages(images: [String], index: Int) {
        var photos = [SKPhoto]()
        for image in images {
            photos.append(SKPhoto.photoWithImageURL(image))
        }
        let browser = SKPhotoBrowser(photos: photos)
        browser.initializePageIndex(index)
        self.present(browser, animated: true, completion: nil)
    }
}
