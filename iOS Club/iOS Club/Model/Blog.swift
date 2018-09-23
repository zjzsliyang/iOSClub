//
//  Blog.swift
//  iOS Club
//
//  Created by Yang Li on 2018/9/21.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit

struct Blog: Decodable {
    let id: Int
    let user: User
    let sharemail: String
    let url: String
    let time: String
}
