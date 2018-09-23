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
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
    
        let suiteDefault = UserDefaults.init(suiteName: groupIdentifier)
        print(suiteDefault!.value(forKey: "email"))
        
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        return []
    }

}
