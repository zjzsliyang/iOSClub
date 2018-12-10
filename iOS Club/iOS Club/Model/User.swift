//
//  User.swift
//  Student Club
//
//  Created by Yang Li on 2018/9/22.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit

struct User: Decodable {
    let username: String
    let university: University
    let user_privilege: Int
    let avatar: String
    let email: String
    let password: String
    let position: String
    let description: String
}
