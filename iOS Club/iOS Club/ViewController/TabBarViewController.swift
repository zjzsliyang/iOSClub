//
//  TabBarViewController.swift
//  iOS Club
//
//  Created by Yang Li on 2018/9/21.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        for item in self.tabBar.items! {
            item.selectedImage?.withRenderingMode(.alwaysOriginal)
            item.image?.withRenderingMode(.alwaysOriginal)
        }
    }
    
}