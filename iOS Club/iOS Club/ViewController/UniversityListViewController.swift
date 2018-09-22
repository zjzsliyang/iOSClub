//
//  UniversityListViewController.swift
//  iOS Club
//
//  Created by 罗忠金 on 2018/9/22.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit
import Alamofire

class UniversityListViewController: UIViewController ,UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "universityCell", for: indexPath) as! UniversityCell
        
        let icon = cell.icon as! UIImageView
        
//        icon.image = UIImage(named: "avatar")

        let url = URL(string:"http://10.0.1.13:8888/university_icon/10247.jpeg")!
        //创建请求对象
        let request = URLRequest(url: url)
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            if error != nil{
                print(error.debugDescription)
            }else{
                //将图片数据赋予UIImage
                let img = UIImage(data:data!)
                icon.image = img
            }
        }) as URLSessionTask
        
        //使用resume方法启动任务
        dataTask.resume()
        
        return cell
        
    }
    

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        
//        Alamofire.request("http://10.0.1.13:8888/club/info/getAll").responseJSON { response in
//
//            if let json = response.result.value {
//
//
//                
//            }
//        }
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
