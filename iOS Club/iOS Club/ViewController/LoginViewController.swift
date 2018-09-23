//
//  LoginViewController.swift
//  iOS Club
//
//  Created by Yang Li on 2018/9/23.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit
import LGButton
import Alamofire
import SwiftyJSON
import TextFieldEffects
import NotificationBannerSwift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    
    @IBAction func login(_ sender: LGButton) {
        sender.isLoading = true
        
        let userParameters: Parameters = [
            "email": emailTextField.text!,
            "password": passwordTextField.text!
        ]
        
        Alamofire.request(backendUrl + "/user/login/", method: .post, parameters: userParameters, encoding: JSONEncoding.default).responseString { (response) in
            let responseData = response.result.value!
            do {
                let responseJson = try JSON(data: responseData.data(using: String.Encoding.utf8)!)
                print(responseJson)
                
                if responseJson["code"] == 0 {
                    let userDefault = UserDefaults.standard
                    userDefault.set(true, forKey: "isLogin")
                    self.autoLogin()
                } else if responseJson["code"] == -1 {
                    self.emailTextField.shake()
                    self.emailTextField.placeholderColor = .red
                    let banner = NotificationBanner(title: "Login Fail", subtitle: "acount does not exist", style: BannerStyle.danger)
                    banner.show()
                } else if responseJson["code"] == 1 {
                    self.passwordTextField.shake()
                    self.passwordTextField.placeholderColor = .red
                    let banner = NotificationBanner(title: "Login Fail", subtitle: "password incorrect", style: BannerStyle.danger)
                    banner.show()
                }
            } catch let error as NSError {
                print(error.code)
                print(error.description)
            }
        }
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        autoLogin()
    }
    
    func autoLogin() {
        let userDefault = UserDefaults.standard
        if userDefault.bool(forKey: "isLogin") {
            self.performSegue(withIdentifier: "login", sender: nil)
        }
    }
}

extension UITextField {
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: self.center.x - 4.0, y: self.center.y)
        animation.toValue = CGPoint(x: self.center.x + 4.0, y: self.center.y)
        layer.add(animation, forKey: "position")
    }
}
