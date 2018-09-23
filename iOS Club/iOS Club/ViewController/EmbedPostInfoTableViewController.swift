//
//  EmbedPostInfoTableViewController.swift
//  iOS Club
//
//  Created by Yang Li on 2018/9/23.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit
import WSTagsField

class EmbedPostInfoTableViewController: UITableViewController {
    
    @IBOutlet var postInfoTableView: UITableView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var tagsField: WSTagsField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postInfoTableView.allowsSelection = false
        tagsField.font = UIFont(name: "Avenir Next", size: 17)
        tagsField.borderWidth = 0
        tagsField.placeholder = "tags"
        tagsField.cornerRadius = 10
        tagsField.layoutMargins = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            print(titleTextField.text)
        } else if indexPath.row == 1 {
            print(tagsField.text)
        }
    }

}
