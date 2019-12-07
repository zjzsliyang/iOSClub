//
//  SignupViewController.swift
//  Student Club
//
//  Created by Yang Li on 2019/1/14.
//  Copyright © 2019 Yang LI. All rights reserved.
//

import UIKit
import LGButton
import Alamofire
import SwiftyJSON
import SafariServices
import TextFieldEffects
import NotificationBannerSwift

class SignupViewController: UIViewController {
    
    @IBOutlet weak var email: HoshiTextField!
    @IBOutlet weak var name: HoshiTextField!
    @IBOutlet weak var newPassword: HoshiTextField!
    @IBOutlet weak var repeatPassword: HoshiTextField!
    @IBOutlet weak var university: HoshiTextField!
    @IBOutlet weak var license: UITextView!
    @IBOutlet weak var checkBox: VKCheckbox!
    
    var universityDict = [Int: String]()
    var universityRank = [Int: Int]()
    var code: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        getUniversityInfo()
        email.autocorrectionType = .no
        university.inputView = UIView(frame: CGRect.zero)
        university.inputAccessoryView = UIView.init()
        
        let eula = NSMutableAttributedString(string: "EULA")
        let pp = NSMutableAttributedString(string: "Privacy Policy")
        eula.addAttribute(.link, value: URL(string: backendUrl + "/files/license/eula.html")!, range: NSRange(location: 0, length: "EULA".count))
        pp.addAttribute(.link, value: URL(string: backendUrl + "/files/license/privacy_policy.html")!, range: NSRange(location: 0, length: "Privacy Policy".count))
        license.attributedText = NSMutableAttributedString(string: "I agree to the ").appendRecursively(eula).appendRecursively(NSMutableAttributedString(string: " and ")).appendRecursively(pp)
        license.delegate = self
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickUniversity(_ sender: HoshiTextField) {
        let universityPicker = UIPickerView(frame: CGRect(x: 0, y: self.view.frame.maxY - 190, width: self.view.frame.width, height: 190))
        universityPicker.backgroundColor = UIColor.white
        universityPicker.delegate = self
        self.view.addSubview(universityPicker)
    }
    
    @IBAction func signup(_ sender: LGButton) {
        if !signupInfoCheck() {
            return
        }
        
        let userParameters: Parameters = [
            "u_code": universityRank[code!]!,
            "email": email.text!,
            "password": newPassword.text!,
            "username": name.text!,
            "user_privilege": 1
        ]
        
        Alamofire.request(backendUrl + "/user/register", method: .post, parameters: userParameters, encoding: JSONEncoding.default).responseString { (response) in
            guard (response.result.value != nil) else {
                log.error(response)
                DispatchQueue.main.async {
                    let banner = NotificationBanner(title: "Signup Fail", subtitle: "Fatal Server Error", style: .danger)
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
                    self.email.placeholderColor = placeholdercolor
                    self.name.placeholderColor = placeholdercolor
                    self.newPassword.placeholderColor = placeholdercolor
                    self.repeatPassword.placeholderColor = placeholdercolor
                }
                
                if responseJson["code"] == 0 {
                    DispatchQueue.main.async {
                        let suiteDefault = UserDefaults.init(suiteName: groupIdentifier)
                        let email = responseJson["user"]["email"].rawString()!
                        suiteDefault?.set(email, forKey: "email")
                        if self.newPassword.text! != "" {
                            suiteDefault?.set(self.newPassword.text!, forKey: "password")
                        }
                        suiteDefault?.synchronize()
                        self.performSegue(withIdentifier: "signup", sender: email)
                    }
                } else if responseJson["code"] == -1 {
                    DispatchQueue.main.async {
                        self.email.shake()
                        self.email.placeholderColor = .red
                        let banner = NotificationBanner(title: "Signup Fail", subtitle: "acount already exists", style: .danger)
                        banner.show()
                    }
                }
            } catch let error as NSError {
                log.error(error)
            }
        }
    }
    
    func signupInfoCheck() -> Bool {
        if (email.text?.contains(" "))! {
            email.shake()
            return false
        }
        if email.text == "" {
            email.shake()
            return false
        }
        if name.text == "" {
            name.shake()
            return false
        }
        if newPassword.text == "" {
            newPassword.shake()
            return false
        }
        if repeatPassword.text != newPassword.text {
            repeatPassword.shake()
            return false
        }
        if university.text == "" {
            university.shake()
            return false
        }
        if !checkBox.isOn() {
            return false
        }
        return true
    }
    
    func getUniversityInfo() {
        Alamofire.request(backendUrl + "/club/info/getAll").responseJSON { (response) in
            if let data = response.result.value {
                let json = JSON(data)
                for item in json.arrayValue {
                    self.universityDict[item["rank"].int!] = item["name"].stringValue
                    self.universityRank[item["rank"].int!] = item["code"].int!
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signup" {            
            let newsViewController = (segue.destination.children[0] as! UINavigationController).children[0] as! NewsViewController
            let email = sender as! String
            newsViewController.email = email
        }
    }
    
}

extension SignupViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return universityDict.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return universityDict[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.university.text = universityDict[row]
        self.code = row
        university.endEditing(true)
        pickerView.removeFromSuperview()
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let safariViewController = SFSafariViewController(url: URL)
        present(safariViewController, animated: true, completion: nil)
        return false
    }
}

extension NSMutableAttributedString {
    func appendRecursively(_ element: NSMutableAttributedString) -> NSMutableAttributedString {
        self.append(element)
        return self
    }
}

class VerticallyCenteredTextView: UITextView {
    override var contentSize: CGSize {
        didSet {
            var topCorrection = (bounds.size.height - contentSize.height * zoomScale) / 2.0
            topCorrection = max(0, topCorrection)
            contentInset = UIEdgeInsets(top: topCorrection, left: 0, bottom: 0, right: 0)
        }
    }
}
