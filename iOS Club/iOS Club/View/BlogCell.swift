//
//  BlogCell.swift
//  Student Club
//
//  Created by Yang Li on 2018/9/24.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit
import URLEmbeddedView

class BlogCell: UITableViewCell {
    
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var previewView: URLEmbeddedView!
    
    func setBlog(blog: Blog) {
        userButton.setTitle(blog.user.username, for: .normal)
        timeLabel.text = blog.time
        do {
            let avatarData = try Data(contentsOf: URL(string: blog.user.avatar)!)
            avatarView.image = UIImage(data: avatarData)
        }
        catch {
            avatarView.image = UIImage(named: "avatar")
        }
        previewView.load(urlString: blog.url)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        previewView.prepareViewsForReuse()
    }

}
