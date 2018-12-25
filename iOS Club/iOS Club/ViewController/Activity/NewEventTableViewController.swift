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
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 3 && indexPath.row == 1 {
            return 88
        } else {
            return 44
        }
    }
}
