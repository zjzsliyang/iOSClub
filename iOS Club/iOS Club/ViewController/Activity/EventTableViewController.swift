//
//  EventTableViewController.swift
//  Student Club
//
//  Created by Yang Li on 2018/12/23.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit
import EventKit
import CoreLocation

class EventTableViewController: UITableViewController, CLLocationManagerDelegate {
    let timePicker = UIDatePicker()
    let formatter = DateFormatter()
    let locationManager = CLLocationManager()
    var isStartTime = true
    var isNew = true
    var currentEvent: EKEvent?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var allDaySwitch: UISwitch!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var timeZoneLabel: UILabel!
    
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var inviteesLabel: UILabel!
    @IBOutlet weak var alertsLabel: UILabel!
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var showAsLabel: UILabel!
    
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCurrentEvent(isNew: isNew, currentEvent: currentEvent)
        
        let currentTime = Date()
        formatter.dateFormat = "EEE, MMM d, YYYY, HH:mm"
        startTimeLabel.text = formatter.string(from: currentTime)
        endTimeLabel.text = formatter.string(from: currentTime.addingTimeInterval(60.0 * 60.0))
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
//        self.locationManager.startUpdatingLocation()
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
//        guard let location = manager.location else{
//            return
//        }
//        let currentLocationCoordinate = location.coordinate
//        print(currentLocationCoordinate)
//    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 3 && indexPath.row == 1 {
            return 88
        } else {
            return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 1 {
                isStartTime = true
                openTimePicker()
            }
            if indexPath.row == 2 {
                isStartTime = false
                openTimePicker()
            }
        }
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
    func openTimePicker()  {
        timePicker.datePickerMode = .dateAndTime
        timePicker.frame = CGRect(x: 0.0, y: (self.view.frame.height - 150), width: self.view.frame.width, height: 150.0)
        timePicker.backgroundColor = .white
        self.view.addSubview(timePicker)
        timePicker.addTarget(self, action: #selector(EventTableViewController.startTimeDiveChanged), for: UIControl.Event.valueChanged)
    }
    
    @objc func startTimeDiveChanged(sender: UIDatePicker) {
        if isStartTime {
            startTimeLabel.text = formatter.string(from: sender.date)
            if sender.date > formatter.date(from: endTimeLabel.text!)! {
                endTimeLabel.text = formatter.string(from: sender.date.addingTimeInterval(60.0 * 60.0))
            }
        } else {
            endTimeLabel.text = formatter.string(from: sender.date)
        }
        timePicker.removeFromSuperview()
    }
    
    func loadCurrentEvent(isNew: Bool, currentEvent: EKEvent?) {
        guard (!isNew) && (currentEvent != nil) else {
            return
        }
        titleTextField.text = currentEvent?.title
        locationTextField.text = currentEvent?.location
        
        allDaySwitch.isOn = currentEvent?.isAllDay ?? false
        formatter.dateFormat = "EEE, MMM d, YYYY, HH:mm"
        startTimeLabel.text = formatter.string(from: (currentEvent?.startDate)!)
        endTimeLabel.text = formatter.string(from: (currentEvent?.endDate)!)

        let splitted = String(describing: currentEvent?.timeZone).split { ["/", "(", ")", " "].contains(String($0)) }
        timeZoneLabel.text = splitted.map { String($0).trimmingCharacters(in: .whitespaces) }[2]
        
        urlTextField.text = String(describing: currentEvent?.url)
        notesTextField.text = currentEvent?.notes
    }
}