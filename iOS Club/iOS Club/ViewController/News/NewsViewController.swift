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
import SKPhotoBrowser
import NotificationBannerSwift

class NewsViewController: UIViewController {
    var email: String?
    
    var newses = [News]()
    let refresher = PullToRefresh()
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var newsSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
        newsTableView.addPullToRefresh(refresher) {
            self.fetchNews()
        }
        setupHideKeyboardOnTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(tableViewCellContentSelected(notification:)), name: NSNotification.Name(rawValue: "tableviewcellselected"), object: nil)
        fetchNews()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func detailImages(images: [String], index: Int) {
        var photos = [SKPhoto]()
        for image in images {
            photos.append(SKPhoto.photoWithImageURL(image))
        }
        let browser = SKPhotoBrowser(photos: photos)
        browser.initializePageIndex(index)
        self.present(browser, animated: true, completion: nil)
    }
    
    @objc func tableViewCellContentSelected(notification: Notification) {
        if let images = notification.userInfo?["images"] as? [String] {
            if let index = notification.userInfo?["index"] as? NSInteger {
                detailImages(images: images, index: index)
            }
        }
    }
    
    func fetchNews() {
        Alamofire.request(backendUrl + "/news/getNews?user_email=" + email!).responseString { (response) in
            guard (response.result.value != nil) else {
                log.error(response)
                DispatchQueue.main.async {
                    let banner = NotificationBanner(title: "Get News Fail", subtitle: "Fatal Server Error", style: .danger)
                    banner.show()
                }
                return
            }
            let responseData = response.result.value!
            do {
                let responseJson = try JSON(data: responseData.data(using: String.Encoding.utf8)!)
                if responseJson["code"] == 0 {
                    self.newses = []
                    if let newsdata = try? JSONDecoder().decode([News].self, from: responseJson["news"].rawData()) {
                        self.newses.append(contentsOf: newsdata)
                        DispatchQueue.main.async {
                            self.newsTableView.reloadData()
                            self.newsTableView.endAllRefreshing()
                        }
                    } else {
                        log.error("fetched JSON parse failed")
                    }
                }
            } catch let error as NSError {
                log.error(error)
            }
        }
    }
    
    @IBAction func more(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Report", style: .destructive, handler: { (action) in
            print(action)
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action) in
            let news = self.newses[(self.newsTableView.indexPath(for: sender)?.row)!]
            let newsParameters: Parameters = ["news_id": news.id,
                                              "user_email": self.email!]
            Alamofire.request(backendUrl + "/news/delete", method: .post, parameters: newsParameters, encoding: JSONEncoding.default).responseString(completionHandler: { (response) in
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
                        self.newses.remove(at: self.newsTableView.indexPath(for: sender)!.row)
                        self.newsTableView.reloadData()
                        let banner = NotificationBanner(title: "Delete Success", subtitle: "delete post titled " + news.title, style: .success)
                        banner.show()
                    } else {
                        let banner = NotificationBanner(title: "Delete Fail", subtitle: responseJson["msg"].rawString(), style: .danger)
                        banner.show()
                    }
                } catch let error as NSError {
                    log.error(error)
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
        if indexPath.row >= newses.count {
            return self.view.frame.size.height
        }
        if (newses[indexPath.row].images != []) || (newses[indexPath.row].video != "") {
            return 370
        } else {
            return 370 - self.view.frame.size.width / 16 * 9
        }
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        if newses.count != 0 {
            let news = newses[indexPath.row]
            cell.setNews(news: news)
        }
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

extension NewsViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if newsSearchBar?.text != "" {
            self.fetchNews()
            newsSearchBar.text = ""
        }
        self.newsTableView.setContentOffset(CGPoint.zero, animated: true)
    }
}

extension NewsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text!.count > 0 {
            Alamofire.request((backendUrl + "/news/search?text=" + searchBar.text! + "&user_email=" + String(describing: email!)).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!).responseString { (response) in
                guard (response.result.value != nil) else {
                    log.error(response)
                    DispatchQueue.main.async {
                        let banner = NotificationBanner(title: "Get Search Result Fail", subtitle: "Fatal Server Error", style: .danger)
                        banner.show()
                    }
                    return
                }
                let responseData = response.result.value!
                do {
                    let responseJson = try JSON(data: responseData.data(using: String.Encoding.utf8)!)
                    if responseJson["code"] == 0 {
                        self.newses = []
                        if let tagNews = try? JSONDecoder().decode([News].self, from: responseJson["tag_list"].rawData()) {
                            self.newses.append(contentsOf: tagNews)
                            DispatchQueue.main.async {
                                self.newsTableView.reloadData()
                            }
                        } else {
                            log.error("fetched JSON parse failed")
                        }
                        if let titleNews = try? JSONDecoder().decode([News].self, from: responseJson["title_list"].rawData()) {
                            self.newses.append(contentsOf: titleNews)
                            DispatchQueue.main.async {
                                self.newsTableView.reloadData()
                            }
                        } else {
                            log.error("fetched JSON parse failed")
                        }
                    }
                } catch let error as NSError {
                    log.error(error)
                }
            }
        }
        self.view.endEditing(true)
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
