//
//  UserData.swift
//  iOS Club
//
//  Created by Yang Li on 2018/9/22.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit

class UserData {
    let username: String
    let university: String
    let privilege: Int
    let avatar: UIImage
    let email: String
    let password: String
    let position: String
    
    init(username: String, university: String, privilege: Int, avatar: String, email: String, password: String, position: String) {
        self.username = username
        self.university = university
        self.privilege = privilege
        let avatarData = try! Data(contentsOf: URL(string: avatar)!)
        self.avatar = UIImage(data: avatarData)!
        self.email = email
        self.password = password
        self.position = position
    }
}
