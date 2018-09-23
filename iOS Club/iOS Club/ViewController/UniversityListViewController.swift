//
//  UniversityListViewController.swift
//  iOS Club
//
//  Created by 罗忠金 on 2018/9/22.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class UniversityListViewController: UIViewController ,UICollectionViewDataSource,UICollectionViewDelegate{
    
    var universityArray:JSON = JSON.null
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.universityArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "universityCell", for: indexPath) as! UniversityCell
        
        let icon = cell.icon as UIImageView
        
//        icon.image = UIImage(named: "avatar")
        let iconUrl  = universityArray[indexPath.item]["icon"].rawString()

        let url = URL(string: iconUrl!)!
        
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
//                    imageCache.setObject(image, forKey: urlString as NSString)
                    icon.image = image
                }
            }
            
        }).resume()
        
        return cell
        
    }
    

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        
        let url:NSURL! = NSURL(string: backendUrl + "/club/info/getAll")
        let urlRequest:NSURLRequest = NSURLRequest(url: url as URL)
        var response:URLResponse?
        
        do{
            let data:NSData? = try NSURLConnection.sendSynchronousRequest(urlRequest as URLRequest,returning: &response) as NSData
            if let value = data {
                let json = JSON(value)
                self.universityArray = json
            }
        }catch let error as NSError{
            //打印错误消息
            print(error.code)
            print(error.description)
        }
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let controller = segue.destination as! UniversityDetailViewController
            let cell = sender as! UICollectionViewCell
            let indexPath = self.collectionView!.indexPath(for: cell)
            controller.university = self.universityArray[(indexPath?.item)!]
        }
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class UniversityCell:UICollectionViewCell{
    
    
    @IBOutlet weak var icon: UIImageView!
    
}
