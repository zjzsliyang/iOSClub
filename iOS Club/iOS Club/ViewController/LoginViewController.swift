//
//  LoginViewController.swift
//  iOS Club
//
//  Created by Yang Li on 2018/9/23.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit
import LGButton
import TextFieldEffects

class LoginViewController: UIViewController {
    
    @IBAction func login(_ sender: LGButton) {
        print("login")
        sender.isLoading = true
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            sender.isLoading = false
            // DO SOMETHING
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHideKeyboardOnTap()
    }
}

