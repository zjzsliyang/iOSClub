//
//  UniversityDetailViewController.swift
//  Student Club
//
//  Created by Zhongjin Luo on 2018/9/22.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
class UniversityDetailViewController: UIViewController {

    var university = JSON.null
    
    @IBOutlet weak var uiniversityIcon: UIImageView!
    @IBOutlet weak var universityDesc: UITextView!
    @IBOutlet weak var teacherName: UILabel!
    @IBOutlet weak var teacherEmail: UITextView!
    @IBOutlet weak var teacherRole: UILabel!
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var studentRole: UILabel!
    @IBOutlet weak var studentEmail: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiniversityIcon.layer.cornerRadius = 30
        uiniversityIcon.layer.masksToBounds = true
        
        self.setImage(imageView: uiniversityIcon,urlString: university["icon"].rawString()!)
        universityDesc.text = university["description"].rawString()
        if #available(iOS 13.0, *) {
            universityDesc.textColor = UIColor.label
        } else {
            // Fallback on earlier versions
        }
        
        let teacherUrl = backendUrl + "/club/teacher/getByCode?code=" + university["code"].rawString()!
        let studentUrl = backendUrl + "/club/sm/getByCode?code=" + university["code"].rawString()!
        
        Alamofire.request(teacherUrl).responseJSON { response in
            if let data = response.result.value {
                let json = JSON(data)[0]
                self.teacherName.text = json["name"].rawString()
                self.teacherRole.text = json["position"].rawString()
                self.teacherEmail.addEmailLink(email: json["email"].rawString() ?? "")
                
            }
        }
        
        Alamofire.request(studentUrl).responseJSON { response in
            
            if let data = response.result.value {
                let json = JSON(data)[0]
                self.studentName.text = json["name"].rawString()
                self.studentRole.text = json["position"].rawString()
                self.studentEmail.addEmailLink(email: json["email"].rawString() ?? "")
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

}

extension UITextView {
    func addEmailLink(email: String = "") {
        let attributedString = NSMutableAttributedString(string: email)
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 10), range: NSRange(location: 0, length: attributedString.length))
        let style = NSMutableParagraphStyle()
        attributedString.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.link, value: "mailto:" + email, range: NSRange(location: 0, length: attributedString.length))
        self.attributedText = attributedString
    }
}
