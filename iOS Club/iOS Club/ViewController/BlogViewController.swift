//
//  BlogViewController.swift
//  iOS Club
//
//  Created by Yang Li on 2018/9/21.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit
import URLEmbeddedView

class BlogViewController: UIViewController {
    
    @IBOutlet weak var blogTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchBlogs()
    }
    
    func fetchBlogs() {
        
    }
    
}
