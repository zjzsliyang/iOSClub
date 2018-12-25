//
//  NewEventTableViewController.swift
//  Student Club
//
//  Created by Yang Li on 2018/12/23.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit

class NewEventTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
}
