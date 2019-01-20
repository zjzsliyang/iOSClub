//
//  ShareViewController.swift
//  Club Share
//
//  Created by Zhongjin Luo on 2018/9/24.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit
import Social
import Alamofire
import SwiftyJSON

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
                    Alamofire.request(backendUrl + "/blog/shareBlog", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseString { (response) in
                        let responseData = response.result.value!
                        do {
                            let responseJson = try JSON(data: responseData.data(using: String.Encoding.utf8)!)
                            if responseJson["code"] != 0 {
                                debugPrint(responseJson)
                            }
                        } catch let error as NSError {
                            debugPrint(error)
                        }
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
