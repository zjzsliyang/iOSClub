//
//  EmbedPostInfoTableViewController.swift
//  Student Club
//
//  Created by Yang Li on 2018/9/23.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit
import WSTagsField

protocol PostInfoProtocol: class {
    func postTitle(title: String)
    func postTags(tags: [String])
    func postPrivilege(description: String)
}

class EmbedPostInfoTableViewController: UITableViewController {
    
    @IBOutlet weak var privilegeTextField: UITextField!
    @IBOutlet var postInfoTableView: UITableView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var tagsField: WSTagsField!
    weak var delegate: PostInfoProtocol? = nil
    
    @IBAction func selectPrivilegeTextField(_ sender: UITextField) {
        let privilegeAlertView = UIAlertController(title: "Post Privilege", message: "choose who can see this post", preferredStyle: .alert)
        
        privilegeAlertView.addAction(UIAlertAction(title: "Only my university members", style: .default, handler: displayPrivilege))
        privilegeAlertView.addAction(UIAlertAction(title: "All university club members", style: .default, handler: displayPrivilege))
        privilegeAlertView.addAction(UIAlertAction(title: "All(including guest)", style: .default, handler: displayPrivilege))
        
        self.present(privilegeAlertView, animated: true, completion: nil)
    }
    
    func displayPrivilege(alert: UIAlertAction) {
        privilegeTextField.text = alert.title
        self.delegate!.postPrivilege(description: self.privilegeTextField.text ?? "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postInfoTableView.allowsSelection = false
        tagsField.font = UIFont(name: "Avenir Next", size: 17)
        tagsField.placeholder = "tags"
        tagsField.acceptTagOption = .space
        tagsField.layoutMargins = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
        tagsField.onDidChangeText = { (_, _) in
            self.delegate!.postTags(tags: self.tagsField.tags.map({ return $0.text }))
        }
    }
}

extension EmbedPostInfoTableViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate!.postTitle(title: titleTextField.text!)
    }
}

