//
//  UniversityListViewController.swift
//  Student Club
//
//  Created by Zhongjin Luo on 2018/9/22.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UniversityListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var universityDict = [Int: JSON]()
    var universityLogo = [UIImage?]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.universityDict.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "universityCell", for: indexPath) as! UniversityCell

        let icon = cell.icon!
        
        if universityLogo[indexPath.item] == nil {
            let iconUrl  = universityDict[indexPath.item]?["icon"].rawString()
            let url = URL(string: iconUrl!)!
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                guard error == nil else {
                    log.error(error)
                    return
                }
                DispatchQueue.main.async {
                    if let image = UIImage(data: data!) {
                        self.universityLogo[indexPath.item] = image
                        icon.image = self.universityLogo[indexPath.item]
                    }
                }
            }).resume()
        } else {
            icon.image = universityLogo[indexPath.item]
        }
        
        return cell
    }
    

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        collectionView.dataSource = self
        
        Alamofire.request(backendUrl + "/club/info/getAll").responseJSON { (response) in
            if let data = response.result.value {
                let json = JSON(data)
                for item in json.arrayValue {
                    self.universityDict[item["code"].int!] = item
                }
                self.universityLogo = [UIImage?](repeating: nil, count: self.universityDict.count)
                self.collectionView.reloadData()
            }
            self.collectionView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let controller = segue.destination as! UniversityDetailViewController
            let cell = sender as! UICollectionViewCell
            let indexPath = self.collectionView!.indexPath(for: cell)
            controller.university = self.universityDict[(indexPath?.item)!]!
        }
    }
}

class UniversityCell: UICollectionViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    
}
