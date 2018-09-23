//
//  BlogViewController.swift
//  iOS Club
//
//  Created by Yang Li on 2018/9/21.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit
import SkeletonView
import URLEmbeddedView

class BlogViewController: UIViewController {
    var blogs = [Blog]()
    @IBOutlet weak var blogTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchBlogs()
    }
    
    func fetchBlogs() {
        if let url = URL(string: backendUrl + "/blog/getAll") {
            let session = URLSession(configuration: .default)
            session.dataTask(with: url) { (data, _, err) in
                guard err == nil else { return }
                guard let data = data else { return }
                if let blogsdata = try? JSONDecoder().decode([Blog].self, from: data) {
                    self.blogs.append(contentsOf: blogsdata)
                    DispatchQueue.main.async {
                        self.blogTableView.reloadData()
                    }
                } else {
                    debugPrint("JSON parse failed")
                }
            }.resume()
        }
    }
}

extension BlogViewController: SkeletonTableViewDataSource, SkeletonTableViewDelegate {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "BlogCell"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let blog = blogs[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlogCell") as! BlogCell
        cell.setBlog(blog: blog)
        return cell
    }
}
