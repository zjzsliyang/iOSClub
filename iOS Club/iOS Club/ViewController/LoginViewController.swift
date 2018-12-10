//
//  LoginViewController.swift
//  Student Club
//
//  Created by Yang Li on 2018/9/23.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit
import LGButton
import Alamofire
import SwiftyJSON
import SPPermission
import TextFieldEffects
import NotificationBannerSwift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    @IBOutlet weak var loginButton: LGButton!
    
    @IBAction func login(_ sender: LGButton) {
        postLogin(email: emailTextField.text!, password: passwordTextField.text!, sender: sender)
    }
    
    @IBAction func guest(_ sender: UIButton) {
        self.performSegue(withIdentifier: "login", sender: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHideKeyboardOnTap()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let suiteDefault = UserDefaults.init(suiteName: groupIdentifier)
        if let email = suiteDefault?.value(forKey: "email") {
            if let password = suiteDefault?.value(forKey: "password") {
                postLogin(email: email as! String, password: password as! String, sender: loginButton)
            }
        }
        
        SPPermission.Dialog.request(with: [.camera, .photoLibrary, .calendar, .notification], on: self)
    }
    
    func postLogin(email: String, password: String, sender: LGButton) {
        sender.isLoading = true
        
        let userParameters: Parameters = [
            "email": email,
            "password": password
        ]
        
        Alamofire.request(backendUrl + "/user/login/", method: .post, parameters: userParameters, encoding: JSONEncoding.default).responseString { (response) in
            guard (response.result.value != nil) else {
                log.error("[LOGIN]: " + String(describing: response))
                DispatchQueue.main.async {
                    let banner = NotificationBanner(title: "Login Fail", subtitle: "Fatal Server Error", style: .danger)
                    banner.show()
                    sender.isLoading = false
                }
                return
            }
            
            let responseData = response.result.value!
            do {
                let responseJson = try JSON(data: responseData.data(using: String.Encoding.utf8)!)
                
                DispatchQueue.main.async {
                    sender.isLoading = false
                    let placeholdercolor = UIColor(hex: "#576576")
                    self.emailTextField.placeholderColor = placeholdercolor
                    self.passwordTextField.placeholderColor = placeholdercolor
                }
                
                if responseJson["code"] == 0 {
                    DispatchQueue.main.async {
                        let suiteDefault = UserDefaults.init(suiteName: groupIdentifier)
                        suiteDefault?.set(responseJson["user"]["email"].rawString()!, forKey: "email")
                        if self.passwordTextField.text! != "" {
                            suiteDefault?.set(self.passwordTextField.text!, forKey: "password")
                        }
                        suiteDefault?.synchronize()
                        self.performSegue(withIdentifier: "login", sender: nil)
                    }
                } else if responseJson["code"] == -1 {
                    DispatchQueue.main.async {
                        self.emailTextField.shake()
                        self.emailTextField.placeholderColor = .red
                        let banner = NotificationBanner(title: "Login Fail", subtitle: "acount does not exist", style: .danger)
                        banner.show()
                    }
                } else if responseJson["code"] == 1 {
                    DispatchQueue.main.async {
                        self.passwordTextField.shake()
                        self.passwordTextField.placeholderColor = .red
                        let banner = NotificationBanner(title: "Login Fail", subtitle: "password incorrect", style: .danger)
                        banner.show()
                    }
                }
            } catch let error as NSError {
                log.error("[LOGIN]: " + String(describing: error))
            }
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
