//
//  User.swift
//  iOS Club
//
//  Created by Yang Li on 2018/9/22.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit

class User {
    let username: String
    let university: University
    let privilege: Int
    let avatar: UIImage
    let email: String
    let password: String
    let position: String
    let description: String
    
    init(username: String, university: University, privilege: Int, avatar: String, email: String, password: String, position: String, description: String) {
        self.username = username
        self.university = university
        self.privilege = privilege
        let avatarData = try! Data(contentsOf: URL(string: avatar)!)
        self.avatar = UIImage(data: avatarData)!
        self.email = email
        self.password = password
        self.position = position
        self.description = description
    }
}

class University {
    let id: String
    let name: String
    let email: String
    
    init(id: String, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
    }
}
