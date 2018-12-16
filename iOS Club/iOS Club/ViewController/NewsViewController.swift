//
//  NewsViewController.swift
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
import NotificationBannerSwift

class NewsViewController: UIViewController {
    var newses = [News]()
    let refresher = PullToRefresh()
    @IBOutlet weak var newsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTableView.addPullToRefresh(refresher) {
            self.fetchNews()
        }
        setupHideKeyboardOnTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchNews()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func fetchNews() {
        newses = []
        let privilege = 5
        if let url = URL(string: backendUrl + "/news/getByPrivilege?u_privilege=" + String(describing: privilege)) {
            let session = URLSession(configuration: .default)
            session.dataTask(with: url) { (data, _, err) in
                guard err == nil else { return }
                guard let data = data else { return }
                if let newsdata = try? JSONDecoder().decode([News].self, from: data) {
                    self.newses.append(contentsOf: newsdata)
                    DispatchQueue.main.async {
                        self.newsTableView.reloadData()
                        self.newsTableView.endAllRefreshing()
                    }
                } else {
                    log.error("[NEWS]: fetched JSON parse failed")
                }
            }.resume()
        }
    }
    
    @IBAction func more(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            let news = self.newses[(self.newsTableView.indexPath(for: sender)?.row)!]
            let newsParameters: Parameters = ["id": news.id]
            Alamofire.request(backendUrl + "/news/delete", method: .post, parameters: newsParameters, encoding: JSONEncoding.default).responseString(completionHandler: { (response) in
                guard (response.result.value != nil) else {
                    log.error("[NEWS]: " + String(describing: response))
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
                        self.newses.remove(at: self.newsTableView.indexPath(for: sender)!.row)
                        self.newsTableView.reloadData()
                        let banner = NotificationBanner(title: "Delete Success", subtitle: "delete post titled " + news.title, style: .success)
                        banner.show()
                    }
                } catch let error as NSError {
                    log.error("[NEWS]: " + String(describing: error))
                }
            })
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}

extension NewsViewController: SkeletonTableViewDataSource, SkeletonTableViewDelegate {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "NewsCell"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newses.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (newses[indexPath.row].images != []) || (newses[indexPath.row].video != "") {
            return 370
        } else {
            return 370 - self.view.frame.size.width / 16 * 9
        }
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let news = newses[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        cell.setNews(news: news)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "newsDetail", sender: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newsDetail" {
            let controller = segue.destination as! NewsDetailViewController
            controller.news = newses[sender as! Int]
        }
    }
}

extension NewsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text!.count > 0 {
            log.debug("[NEWS]: search news: " + searchBar.text!)
        }
    }
}

extension UIViewController {
    func setupHideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }
    
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
}

extension UITableView {
    func indexPath(for view: UIView) -> IndexPath? {
        let location = view.convert(CGPoint.zero, to: self)
        return self.indexPathForRow(at: location)
    }
}
