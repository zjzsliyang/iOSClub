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

class MeViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var personalDescription: UITextView!
    @IBOutlet weak var email: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let emailAddress = "zhuhongming@tongji.edu.cn"
        
        avatar.layer.masksToBounds = true
        avatar.layer.cornerRadius = avatar.frame.width / 2
        
        avatar.isUserInteractionEnabled = true
        
        Alamofire.request(backendUrl + "/user/getInfoByEmail?email=" + emailAddress).responseJSON { response in
            
            if let data = response.result.value {
                let json = JSON(data)
                self.name.text = json["username"].rawString()
                self.position.text = json["position"].rawString()
                self.email.text = json["email"].rawString()
                
                let url = URL(string: json["avatar"].rawString()!)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                    guard error == nil else {
                        debugPrint(error!)
                        return
                    }
                    DispatchQueue.main.async {
                        if let image = UIImage(data: data!) {
                            self.avatar.image = image
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
        
        let parameters = ["email": "zhuhongming@tongji.edu.cn"]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "file",fileName: "file.jpg", mimeType: "image/jpg")
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: backendUrl + "/user/upload"){ (result) in }
        
        avatar.image = image
        picker.dismiss(animated: true, completion:nil)
    }
  
    @IBAction func test(_ sender: Any) {
        
        let image = avatar.image
        let imgData = UIImageJPEGRepresentation(image!, 0.2)!
        
        let parameters = ["req": "zhuhongming@tongji.edu.cn"]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "file",fileName: "file.jpg", mimeType: "image/jpg")
            multipartFormData.append(imgData, withName: "file",fileName: "file2.jpg", mimeType: "image/jpg")
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: backendUrl + "/news/upload"){ (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    
                })
                
                upload.responseJSON { response in
                    
                }
                
            case .failure(let encodingError): break
            }
        }
        
    }
    
}


