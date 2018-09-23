//
//  ShareViewController.swift
//  Club Share
//
//  Created by 罗忠金 on 2018/9/24.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit
import Social
import Alamofire

class ShareViewController: SLComposeServiceViewController {
    
    override func isContentValid() -> Bool {
        return true
    }
    
    override func didSelectPost() {
        
        let suiteDefault = UserDefaults.init(suiteName: groupIdentifier)
        let email = suiteDefault!.value(forKey: "email") as! String
        if let item = extensionContext?.inputItems.first as? NSExtensionItem,
            let itemProvider = item.attachments?.first,
            itemProvider.hasItemConformingToTypeIdentifier("public.url") {
            itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil) { (url, error) in
                if let shareURL = url as? URL {
                    let parameters: Parameters = [
                        "sharemail": email,
                        "url": "\(shareURL)"
                    ]
                    Alamofire.request(backendUrl + "/blog/shareBlog", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {
                        (response) in
                        print(response)
                    }
                }
            }
        }
        
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        
    }
    
    override func configurationItems() -> [Any]! {
        return []
    }
    
}
