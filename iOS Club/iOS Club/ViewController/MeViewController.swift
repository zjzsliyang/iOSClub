//
//  MeViewController.swift
//  iOS Club
//
//  Created by Yang Li on 2018/9/21.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import VegaScrollFlowLayout

class MeViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var personalDescription: UITextView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var descriptionView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let suiteDefault = UserDefaults.init(suiteName: groupIdentifier)
        let email = suiteDefault!.value(forKey: "email") as! String
        
        avatarView.layer.masksToBounds = true
        avatarView.layer.cornerRadius = avatarView.frame.width / 2
        avatarView.isUserInteractionEnabled = true
        
        Alamofire.request(backendUrl + "/user/getInfoByEmail?email=" + email).responseJSON { response in
            
            if let data = response.result.value {
                let json = JSON(data)
                self.nameLabel.text = json["username"].rawString()
                self.positionLabel.text = json["position"].rawString()
                self.emailLabel.text = json["email"].rawString()
                self.descriptionView.text = json["description"].rawString()
                
                let url = URL(string: json["avatar"].rawString()!)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                    guard error == nil else {
                        log.error("[ME]: " + String(describing: error))
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
    }
    
    @IBAction func choose(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imgData = UIImageJPEGRepresentation(image, 0.2)!
        
        let suiteDefault = UserDefaults.init(suiteName: groupIdentifier)
        let email = suiteDefault!.value(forKey: "email") as! String
        let parameters = ["email": email]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "file",fileName: "file.jpg", mimeType: "image/jpg")
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: backendUrl + "/user/upload"){ (result) in }
        
        avatarView.image = image
        picker.dismiss(animated: true, completion:nil)
    }
    
}


