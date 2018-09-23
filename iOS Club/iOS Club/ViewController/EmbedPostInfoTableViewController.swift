//
//  EmbedPostInfoTableViewController.swift
//  iOS Club
//
//  Created by Yang Li on 2018/9/23.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit

class EmbedPostInfoTableViewController: UITableViewController {
    
    @IBOutlet var postInfoTableView: UITableView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var tagsTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postInfoTableView.allowsSelection = false
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            print(titleTextField.text)
        } else if indexPath.row == 1 {
            print(tagsTextField)
        }
    }

}
