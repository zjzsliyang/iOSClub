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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHideKeyboardOnTap()
    }
    
    func requestNews() {
        Alamofire.request(backendUrl).responseJSON { (response) in
            print(response)
            self.newses = []
            
        }
    }

}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let news = newses[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsCell
        cell.setNews(news: news)
        return cell
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
