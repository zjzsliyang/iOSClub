//
//  EventDetailViewController.swift
//  Student Club
//
//  Created by Yang Li on 2019/1/12.
//  Copyright © 2019 Yang LI. All rights reserved.
//

import UIKit
import EventKit

class EventDetailViewController: UIViewController {
    var eventDetailTableViewController: EventTableViewController?
    var event: EKEvent?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "eventdetail" {
            let viewcontroller = segue.destination as! EventTableViewController
            viewcontroller.isNew = false
            viewcontroller.currentEvent = event
        }
    }
}
