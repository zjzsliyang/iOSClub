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
class MeViewController: UIViewController {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var position: UILabel!
    

  
    @IBOutlet weak var personalDescription: UITextView!
    
    @IBOutlet weak var email: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let emailAddress = "zhuhongming@tongji.edu.cn"
        

        avatar.layer.masksToBounds = true
        avatar.layer.cornerRadius = avatar.frame.width/2
        
        Alamofire.request(backendUrl+"/user/getInfoByEmail?email="+emailAddress).responseJSON { response in
            debugPrint(response)
            
            if let data = response.result.value {
                let json = JSON(data)
                self.name.text = json["username"].rawString()
                self.position.text = json["position"].rawString()
                self.email.text = json["email"].rawString()
                
                let url = URL(string: json["avatar"].rawString()!)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                    if error != nil {
                        print(error!)
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

}
