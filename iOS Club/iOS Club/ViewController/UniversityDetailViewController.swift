//
//  UniversityDetailViewController.swift
//  iOS Club
//
//  Created by 罗忠金 on 2018/9/22.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
class UniversityDetailViewController: UIViewController {

    var university:JSON = JSON.null
    
    @IBOutlet weak var uiniversityIcon: UIImageView!
    
    
    @IBOutlet weak var universityDesc: UITextView!
    
    @IBOutlet weak var teacherIcon: UIImageView!
    
    @IBOutlet weak var teacherName: UILabel!
    
    
    @IBOutlet weak var teacherEmail: UILabel!
    

    @IBOutlet weak var teacherRole: UILabel!
    
    @IBOutlet weak var studentIcon: UIImageView!
    
    @IBOutlet weak var studentName: UILabel!
    

    @IBOutlet weak var studentRole: UILabel!
    
    @IBOutlet weak var studentEmail: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiniversityIcon.layer.cornerRadius = 30
        uiniversityIcon.layer.masksToBounds = true
        
        teacherIcon.layer.cornerRadius = 30
        teacherIcon.layer.masksToBounds = true
        
        studentIcon.layer.cornerRadius = 30
        studentIcon.layer.masksToBounds = true
        
   
        
        self.setImage(imageView: uiniversityIcon,urlString: university["icon"].rawString()!)
        universityDesc.text = university["description"].rawString()
        
        let teacherUrl = backendUrl + "/club/teacher/getByCode?code=" + university["code"].rawString()!
        let studentUrl = backendUrl + "/club/sm/getByCode?code=" + university["code"].rawString()!
        
        Alamofire.request(teacherUrl).responseJSON { response in
            debugPrint(response)
            
            if let data = response.result.value {
                let json = JSON(data)[0]
                self.teacherName.text = json["name"].rawString()
                self.teacherRole.text = json["position"].rawString()
                 self.studentEmail.text = json["email"].rawString()
                
                self.setImage(imageView: self.teacherIcon,urlString: json["avatar"].rawString()!)
                
            }
        }
        
        Alamofire.request(studentUrl).responseJSON { response in
            debugPrint(response)
            
            if let data = response.result.value {
                let json = JSON(data)[0]
                print(json)
                self.studentName.text = json["name"].rawString()
                self.studentRole.text = json["position"].rawString()
                self.studentEmail.text = json["email"].rawString()
                self.setImage(imageView: self.studentIcon,urlString: json["avatar"].rawString()!)
            }
        }
        
    }
    

    func setImage(imageView:UIImageView, urlString:String) -> Void {
        
        let url = URL(string: urlString)
        let data = try? Data(contentsOf: url!)
        if data != nil {
            let image = UIImage(data: data!)
            imageView.image = image
        }
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
