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
}

class EmbedPostInfoTableViewController: UITableViewController {
    
    @IBOutlet var postInfoTableView: UITableView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var tagsField: WSTagsField!
    weak var delegate: PostInfoProtocol? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postInfoTableView.allowsSelection = false
        tagsField.font = UIFont(name: "Avenir Next", size: 17)
        tagsField.borderWidth = 0
        tagsField.placeholder = "tags"
        tagsField.cornerRadius = 10
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

