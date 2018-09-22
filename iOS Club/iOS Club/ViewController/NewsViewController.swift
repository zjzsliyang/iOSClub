//
//  NewsViewController.swift
//  iOS Club
//
//  Created by Yang Li on 2018/9/21.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit
import Alamofire
import SkeletonView

class NewsViewController: UIViewController {
    var newses = [News]()
    @IBOutlet weak var newsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNews()
        setupHideKeyboardOnTap()
    }
    
    func fetchNews() {
        if let url = URL(string: backendUrl + "/news/getByPrivilege?u_privilege=" + "5") {
            let session = URLSession(configuration: .default)
            session.dataTask(with: url) { (data, _, err) in
                guard err == nil else { return }
                guard let data = data else { return }
                if let newsdata = try? JSONDecoder().decode([News].self, from: data) {
                    self.newses.append(contentsOf: newsdata)
                    DispatchQueue.main.async {
                        self.newsTableView.reloadData()
                    }
                } else {
                    print("JSON parse failed")
                }
            }.resume()
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsCell
        cell.setNews(news: news)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        TODO
    }
}

extension NewsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text!.count > 0 {
            print("search in news: " + searchBar.text!)
            Alamofire.request(backendUrl).response { (response) in
                print(response)
            }
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
