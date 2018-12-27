//
//  EventViewController.swift
//  Student Club
//
//  Created by Yang Li on 2018/12/19.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NotificationBannerSwift

class EventViewController: UIViewController {
    var newEventTableViewController: NewEventTableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(hex: "#F6F8F9")
    }

    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        print(getFormattedDate(date: (newEventTableViewController?.startTimeLabel.text)!))
    }
    
    @IBAction func add(_ sender: UIBarButtonItem) {
        let title = newEventTableViewController?.titleTextField.text
        let location = newEventTableViewController?.locationTextField.text
        let startTime = newEventTableViewController?.startTimeLabel.text
        let endTime = newEventTableViewController?.endTimeLabel.text
        let eventParameters: Parameters = [
            "title": title!,
            "location": location ?? "",
            "startTime": getFormattedDate(date: startTime!),
            "endTime": getFormattedDate(date: endTime!),
            "alarms": "alarms",
            "url": "url",
            "startTimeZone": ""
        ]
        print(eventParameters)
        Alamofire.request(backendUrl + "/events/create", method: .post, parameters: eventParameters, encoding: JSONEncoding.default).responseString { (response) in
            guard (response.result.value != nil) else {
                log.error("[NEWS]: " + String(describing: response))
                DispatchQueue.main.async {
                    let banner = NotificationBanner(title: "Add Event Fail", subtitle: "Fatal Server Error", style: .danger)
                    banner.show()
                }
                return
            }
            
            let responseData = response.result.value!
            print(responseData)
            do {
                let responseJson = try JSON(data: responseData.data(using: String.Encoding.utf8)!)
                if responseJson["code"] == 0 {
                    let banner = NotificationBanner(title: "Post Success", subtitle: nil, style: .success)
                    banner.show()
                }
            } catch let error as NSError {
                log.error("[NEWS]: " + String(describing: error))
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newevent" {
            if let destinationViewController = segue.destination as? NewEventTableViewController {
                newEventTableViewController = destinationViewController
            }
        }
    }
    
    func getFormattedDate(date: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM d, YYYY, HH:mm"
        let formattedDate = formatter.date(from: date)
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: formattedDate!)
    }
}
