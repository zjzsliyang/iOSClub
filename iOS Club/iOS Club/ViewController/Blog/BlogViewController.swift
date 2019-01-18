//
//  BlogViewController.swift
//  Student Club
//
//  Created by Yang Li on 2018/9/21.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SkeletonView
import PullToRefresh
import SafariServices
import URLEmbeddedView
import NotificationBannerSwift

class BlogViewController: UIViewController {
    var blogs = [Blog]()
    let refresher = PullToRefresh()
    @IBOutlet weak var blogTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        blogTableView.addPullToRefresh(refresher) {
            self.fetchBlogs()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchBlogs()
    }
    
    func deleteBlog(indexPath: IndexPath) {
        let suiteDefault = UserDefaults.init(suiteName: groupIdentifier)
        let userPrivilege = suiteDefault!.integer(forKey: "user_privilege")
        
        
        let blogParameters: Parameters = ["user_privilege": userPrivilege,
                                          "id": blogs[indexPath.item].id]
        Alamofire.request(backendUrl + "/blog/delete", method: .post, parameters: blogParameters, encoding: JSONEncoding.default).responseString { (response) in
            guard (response.result.value != nil) else {
                log.error(response)
                DispatchQueue.main.async {
                    let banner = NotificationBanner(title: "Delete Fail", subtitle: "Fatal Server Error", style: .danger)
                    banner.show()
                }
                return
            }
            let responseData = response.result.value!
            do {
                let responseJson = try JSON(data: responseData.data(using: String.Encoding.utf8)!)
                if responseJson["code"] == 0 {
                    self.blogs.remove(at: indexPath.item)
                    self.blogTableView.reloadData()
                    let banner = NotificationBanner(title: "Delete Success", subtitle: nil, style: .success)
                    banner.show()
                }
            } catch let error as NSError {
                log.error(error)
            }
        }
    }
    
    func fetchBlogs() {
        blogs = []
        if let url = URL(string: backendUrl + "/blog/getAll") {
            let session = URLSession(configuration: .default)
            session.dataTask(with: url) { (data, _, err) in
                guard err == nil else { return }
                guard let data = data else { return }
                if let blogsdata = try? JSONDecoder().decode([Blog].self, from: data) {
                    self.blogs.append(contentsOf: blogsdata)
                    DispatchQueue.main.async {
                        self.blogTableView.reloadData()
                        self.blogTableView.endAllRefreshing()
                    }
                } else {
                    log.error("JSON parse failed")
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let blog = blogs[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlogCell") as! BlogCell
        cell.setBlog(blog: blog)
        
        cell.previewView.didTapHandler = { [weak self] previewView, URL in
            guard let URL = URL else { return }
            if #available(iOS 9.0, *) {
                self?.present(SFSafariViewController(url: URL), animated: true, completion: nil)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteBlog(indexPath: indexPath)
        }
    }
}
