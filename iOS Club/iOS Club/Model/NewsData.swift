//
//  NewsData.swift
//  iOS Club
//
//  Created by Yang Li on 2018/9/21.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit

class NewsData {
    let postname: String
    let avatar: UIImage
    let time: String
    let title: String
    let content: String
    let video: String?
    var images: [UIImage]
    var tags: [String]
    let privilege: Int
    
    init(postname: String, avatar: String, time: String, title: String, content: String, video: String?, images: [String], tags: [String], privilege: Int) {
        self.postname = postname
        let avatarData = try! Data(contentsOf: URL(string: avatar)!)
        self.avatar = UIImage(data: avatarData)!
        self.time = time
        self.title = title
        self.content = content
        self.video = video
        self.images = []
        for imageUrl in images {
            let imageData = try! Data(contentsOf: URL(string: imageUrl)!)
            self.images.append(UIImage(data: imageData)!)
        }
        self.tags = []
        for tag in tags {
            self.tags.append(tag)
        }
        self.privilege = privilege
    }
}
