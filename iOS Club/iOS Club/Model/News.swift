//
//  News.swift
//  Student Club
//
//  Created by Yang Li on 2018/9/21.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit

struct News: Decodable {
    let user: User
    let time: String
    let title: String
    let content: String
    let video: String?
    var images: [String]
    var tags: [String]
    let news_privilege: Int
    let id: Int
}
