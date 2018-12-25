//
//  EventViewController.swift
//  Student Club
//
//  Created by Yang Li on 2018/12/19.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(hex: "#F6F8F9")
    }

    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func add(_ sender: UIBarButtonItem) {
//        TODO: add event here
    }
    
    
}
