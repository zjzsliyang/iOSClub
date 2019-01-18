//
//  MeViewController.swift
//  Student Club
//
//  Created by Yang Li on 2018/9/21.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NotificationBannerSwift

class MeViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var personalDescription: UITextView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let suiteDefault = UserDefaults.init(suiteName: groupIdentifier)
        
        if let email = suiteDefault!.value(forKey: "email") {
            avatarView.layer.masksToBounds = true
            avatarView.layer.cornerRadius = avatarView.frame.width / 2
            avatarView.isUserInteractionEnabled = true
            
            Alamofire.request(backendUrl + "/user/getInfoByEmail?email=" + String(describing: email)).responseJSON { response in
                
                if let data = response.result.value {
                    let json = JSON(data)
                    self.nameLabel.text = json["username"].rawString()
                    self.positionLabel.text = json["position"].rawString()
                    self.emailLabel.text = json["email"].rawString()
                    self.descriptionView.text = json["description"].rawString()
                    
                    let url = URL(string: json["avatar"].rawString()!)
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        guard error == nil else {
                            log.error(error!)
                            return
                        }
                        DispatchQueue.main.async {
                            if let image = UIImage(data: data!) {
                                self.avatarView.image = image
                            }
                        }
                    }).resume()
                }
            }
        } else {
            presentGuestView()
            logoutButton.title = "Login"
        }
    }
    
    func changePassword(email: String, newPassword: String, oldPassword: String) {
        let parameters = [
            "email": email,
            "newPassword": newPassword,
            "oldPassword": oldPassword
        ]
        
        Alamofire.request(backendUrl + "/user/changePassword", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseString { (response) in
            guard (response.result.value != nil) else {
                log.error(response)
                DispatchQueue.main.async {
                    let banner = NotificationBanner(title: "Change Password Fail", subtitle: "Fatal Server Error", style: .danger)
                    banner.show()
                }
                return
            }
            let responseData = response.result.value!
            do {
                let responseJson = try JSON(data: responseData.data(using: String.Encoding.utf8)!)
                
                if responseJson["code"] == 0 {
                    DispatchQueue.main.async {
                        let banner = NotificationBanner(title: "Change Password Success", subtitle: nil, style: .danger)
                        banner.show()
                    }
                } else if responseJson["code"] == 2 {
                    DispatchQueue.main.async {
                        let banner = NotificationBanner(title: "Change Password Fail", subtitle: "Old Password Incorrect", style: .danger)
                        banner.show()
                    }
                } else if responseJson["code"] == 1 {
                    DispatchQueue.main.async {
                        let banner = NotificationBanner(title: "Change Password Fail", subtitle: "Unknown Error", style: .danger)
                        banner.show()
                    }
                }
            } catch let error as NSError {
                log.error(error)
            }
        }
    }
    
    func presentGuestView() {
        let webView = UIWebView(frame: view.frame)
        let url: URL! = URL(string: staticUrl + "/iOS_Club_Playbook.pdf")
        webView.loadRequest(URLRequest(url: url))
        view.addSubview(webView)
    }
    
    @IBAction func choose(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }
    }

    @IBAction func logout(_ sender: UIBarButtonItem) {
        let suiteDefault = UserDefaults.init(suiteName: groupIdentifier)
        suiteDefault?.removeObject(forKey: "email")
        suiteDefault?.removeObject(forKey: "password")
        self.tabBarController?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        let imgData = image.jpegData(compressionQuality: 1)
        
        let suiteDefault = UserDefaults.init(suiteName: groupIdentifier)
        let email = suiteDefault!.value(forKey: "email") as! String
        let parameters = ["email": email]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData!, withName: "file",fileName: "file.jpg", mimeType: "image/jpg")
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: backendUrl + "/user/upload"){ (result) in }
        
        avatarView.image = image
        picker.dismiss(animated: true, completion:nil)
    }
    
}
