//
//  NewEventViewController.swift
//  Student Club
//
//  Created by Yang Li on 2018/12/19.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import NotificationBannerSwift

class NewEventViewController: UIViewController, EventTableViewControllerDelegate {
    var newEventTableViewController: EventTableViewController?
    var placeCoordinate: CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(hex: "#F6F8F9")
    }

    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func add(_ sender: UIBarButtonItem) {
        var location = ""
        if placeCoordinate != nil {
            location = placeCoordinate!.toString()
        }
        
        let suiteDefault = UserDefaults.init(suiteName: groupIdentifier)
        let email = suiteDefault!.value(forKey: "email") as! String
        let eventPrivilege = 1
        
        let title = newEventTableViewController?.titleTextField.text
        
        let allDay = (newEventTableViewController?.allDaySwitch.isOn)! ? 1 : 0
        let startTime = newEventTableViewController?.startTimeLabel.text
        let endTime = newEventTableViewController?.endTimeLabel.text
        let timeZone = newEventTableViewController?.timeZoneLabel.text
        
        let repeatTime = newEventTableViewController?.repeatLabel.text
        let invitees = [newEventTableViewController?.inviteesLabel.text!]
        let alerts = [newEventTableViewController!.alertsLabel!.text!]
        
        let calendar = newEventTableViewController?.calendarLabel.text
        let showAs = newEventTableViewController?.showAsLabel.text
        
        let url = newEventTableViewController?.urlTextField.text
        let notes = newEventTableViewController?.notesTextField.text
        
        let eventParameters: Parameters = [
            "title": title!,
            "location": location ?? "",
            
            "allDay": allDay,
            "startTime": getFormattedDate(date: startTime!),
            "endTime": getFormattedDate(date: endTime!),
            "timeZone": timeZone ?? "",
            
            "repeatTime": repeatTime ?? "",
            "invitees": invitees,
            "alerts": alerts,
            "calendar": calendar ?? "iOS Club",
            "showAs": showAs ?? "",
            
            "url": url ?? "",
            "notes": notes ?? "",
            
            "event_privilege": eventPrivilege,
            "user_email": email
        ]
        Alamofire.request(backendUrl + "/events/create", method: .post, parameters: eventParameters, encoding: JSONEncoding.default).responseString { (response) in
            guard (response.result.value != nil) else {
                log.error(response)
                DispatchQueue.main.async {
                    let banner = NotificationBanner(title: "Add Event Fail", subtitle: "Fatal Server Error", style: .danger)
                    banner.show()
                }
                return
            }
            
            let responseData = response.result.value!
            do {
                let responseJson = try JSON(data: responseData.data(using: String.Encoding.utf8)!)
                if responseJson["code"] == 0 {
                    let banner = NotificationBanner(title: "Create Success", subtitle: nil, style: .success)
                    banner.show()
                } else {
                    let banner = NotificationBanner(title: "Create Fail", subtitle: nil, style: .danger)
                    banner.show()
                }
            } catch let error as NSError {
                log.error(error)
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newevent" {
            if let destinationViewController = segue.destination as? EventTableViewController {
                destinationViewController.delegate = self
                newEventTableViewController = destinationViewController
            }
        }
    }
    
    func setLocationCoordinate(coordinate: CLLocationCoordinate2D) {
        self.placeCoordinate = coordinate
    }
    
    func getFormattedDate(date: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM d, yyyy, HH:mm"
        let formattedDate = formatter.date(from: date)
        formatter.dateFormat = "yyyy-MM-d HH:mm"
        return formatter.string(from: formattedDate!)
    }
}
