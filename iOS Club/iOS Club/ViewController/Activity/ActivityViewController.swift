//
//  ActivityViewController.swift
//  Student Club
//
//  Created by Yang Li on 2018/9/21.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit
import EventKit
import Alamofire
import VACalendar
import SwiftyJSON
import NotificationBannerSwift

class ActivityViewController: UIViewController {
    
    var nowevents = [EKEvent]()
    var allevents = [EKEvent]()
    let eventStore = EKEventStore()
    var iOSCalendar: EKCalendar?
    var nowids = [Int]()
    @IBOutlet weak var activityTableView: UITableView!
    
    @IBOutlet weak var monthHeaderView: VAMonthHeaderView! {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "LLLL"
            
            let appereance = VAMonthHeaderViewAppearance(
                previousButtonImage: #imageLiteral(resourceName: "previous"),
                nextButtonImage: #imageLiteral(resourceName: "next"),
                addEventButtonImage: UIImage(named: "add")!,
                dateFormatter: dateFormatter
            )
            monthHeaderView.delegate = self
            monthHeaderView.appearance = appereance
        }
    }
    
    @IBOutlet weak var weekDaysView: VAWeekDaysView! {
        didSet {
            let appereance = VAWeekDaysViewAppearance(symbolsType: .veryShort, calendar: defaultCalendar)
            weekDaysView.appearance = appereance
        }
    }
    
    let defaultCalendar: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        calendar.timeZone = TimeZone.current
        return calendar
    }()
    
    var calendarView: VACalendarView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        getEvents()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let calendar = VACalendar(calendar: defaultCalendar)
        calendarView = VACalendarView(frame: .zero, calendar: calendar)
        calendarView.showDaysOut = true
        calendarView.selectionStyle = .single
        calendarView.monthDelegate = monthHeaderView
        calendarView.dayViewAppearanceDelegate = self
        calendarView.monthViewAppearanceDelegate = self
        calendarView.calendarDelegate = self
        calendarView.scrollDirection = .horizontal
        
        self.activityTableView.tableFooterView?.backgroundColor = .black
        self.activityTableView.backgroundColor = .black
        self.activityTableView.separatorColor = .darkGray
        
        iOSCalendar = getCalendar(eventStore: eventStore)
        var activityCalendar = NSCalendar.current
        activityCalendar.timeZone = TimeZone.current
        let startToday = activityCalendar.startOfDay(for: NSDate() as Date)
        updateTodayActivity(startDay: startToday as Date)
        updateActivity()
        view.addSubview(calendarView)
    }
    
    func getCalendar(eventStore: EKEventStore) -> EKCalendar? {
        let calendars = eventStore.calendars(for: .event)
        var iOSCalendar: EKCalendar? = nil
        for calendar in calendars {
            if calendar.title == "iOS Club" {
                iOSCalendar = calendar
            }
        }
        if iOSCalendar == nil {
            iOSCalendar = EKCalendar(for: .event, eventStore: eventStore)
            iOSCalendar!.title = "iOS Club"
            var iCloudSource: EKSource? = nil
            for source in eventStore.sources {
                if (source.sourceType == .calDAV) && (source.title == "iCloud") {
                    iCloudSource = source
                    break
                }
            }
            if (iCloudSource) != nil {
                iOSCalendar!.source = iCloudSource
                do {
                    try eventStore.saveCalendar(iOSCalendar!, commit: true)
                } catch {
                    DispatchQueue.main.async {
                        let banner = NotificationBanner(title: "Create Calendar Fail", subtitle: (error as NSError).localizedDescription, style: .danger)
                        banner.show()
                    }
                }
            }
        }
        return iOSCalendar
    }
    
    func updateTodayActivity(startDay: Date) {
        eventStore.requestAccess(to: .event) { (granted, error) in
            if granted && (error == nil) {
                var calendar = NSCalendar.current
                calendar.timeZone = TimeZone.current
                let components = NSDateComponents()
                components.day = 1
                components.second = -1
                let endToday = calendar.date(byAdding: components as DateComponents, to: startDay)!
                let nowpredicate = self.eventStore.predicateForEvents(withStart: startDay, end: endToday, calendars: [self.iOSCalendar!])
                self.nowevents = self.eventStore.events(matching: nowpredicate)
                DispatchQueue.main.async {
                    self.updateActivity()
                    self.activityTableView.reloadData()
                }
            }
        }
    }
    
    func updateActivity() {
        eventStore.requestAccess(to: .event) { (granted, error) in
            if granted && (error == nil) {
                let startDate = NSDate(timeIntervalSinceNow: -6*31*24*3600)
                let endDate = NSDate(timeIntervalSinceNow: +6*31*24*3600)
                
                let predicate = self.eventStore.predicateForEvents(withStart: startDate as Date, end: endDate as Date, calendars: [self.iOSCalendar!])
                self.allevents = self.eventStore.events(matching: predicate)
                
                DispatchQueue.main.async {
                    for event in self.allevents {
                        self.calendarView.setSupplementaries([
                            (event.startDate!, [VADaySupplementary.bottomDots([.red])]),
                            ])
                    }
                    self.activityTableView.reloadData()
                }
            }
        }
    }
    
    
    
    func deleteEvent(indexPath: IndexPath) {
        if nowevents[indexPath.row].eventIdentifier == nil {
            self.allevents.remove(self.nowevents[indexPath.row])
            self.nowevents.remove(at: indexPath.row)
            self.activityTableView.reloadData()
            DispatchQueue.main.async {
                for event in self.allevents {
                    self.calendarView.setSupplementaries([
                        (event.startDate!, [VADaySupplementary.bottomDots([.red])]),
                        ])
                }
            }
            return
        }
        
        let eventParameters: Parameters = ["u_hash": nowevents[indexPath.row].eventIdentifier!]
        Alamofire.request(backendUrl + "/events/deleteByHash", method: .post, parameters: eventParameters, encoding: JSONEncoding.default).responseString { (response) in
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
                    do {
                        try self.eventStore.remove(self.nowevents[indexPath.row], span: .thisEvent)
                        print(self.allevents.contains(self.nowevents[indexPath.row]))
                        self.allevents.remove(at: self.allevents.indexes(of: self.nowevents[indexPath.row]).last!)
                        print(self.allevents.count)
                        self.nowevents.remove(at: indexPath.row)
                        self.activityTableView.reloadData()
                        print(self.allevents.count)
                        for event in self.allevents {
                            self.calendarView.setSupplementaries([
                                (event.startDate!, [VADaySupplementary.bottomDots([.red])]),
                                ])
                        }
                        print(self.allevents.count)
                        DispatchQueue.main.async {
                            print("async " + String(self.allevents.count))
                            for event in self.allevents {
                                print(event)
                                self.calendarView.setSupplementaries([
                                    (event.startDate!, [VADaySupplementary.bottomDots([.red])]),
                                    ])
                            }
                        }
                    } catch let error {
                        log.error(error)
                    }
                } else if responseJson["code"] == 1 {
                    DispatchQueue.main.async {
                        let banner = NotificationBanner(title: "Delete Fail", subtitle: "Unknown Error", style: .danger)
                        banner.show()
                    }
                } else if responseJson["code"] == 2 {
                    do {
                        self.allevents.remove(self.nowevents[indexPath.row])
                        try self.eventStore.remove(self.nowevents[indexPath.row], span: .thisEvent)
                        DispatchQueue.main.async {
                            self.nowevents.remove(at: indexPath.row)
                            self.activityTableView.reloadData()
                            for event in self.allevents {
                                self.calendarView.setSupplementaries([
                                    (event.startDate!, [VADaySupplementary.bottomDots([.red])]),
                                    ])
                            }
                        }
                    } catch let error {
                        log.error(error)
                    }
                }
            } catch let error as NSError {
                log.error(error)
            }
            
        }
    }
    
    func postEventSaved(email: String, u_hash: String, id: Int) {
        let parameters: Parameters = [
            "e_id": id,
            "u_mail": email,
            "u_hash": u_hash
        ]
        
        Alamofire.request(backendUrl + "/events/setHash", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseString { (response) in
            guard (response.result.value != nil) else {
                log.error(response)
//                DispatchQueue.main.async {
//                    let banner = NotificationBanner(title: "Save Fail", subtitle: "Fatal Server Error", style: .danger)
//                    banner.show()
//                }
                return
            }
            let responseData = response.result.value!
            do {
                let responseJson = try JSON(data: responseData.data(using: String.Encoding.utf8)!)
                if responseJson["code"] == 0 {
//                    DispatchQueue.main.async {
//                        let banner = NotificationBanner(title: "Save Success", subtitle: "Save to iCloud Calendar", style: .success)
//                        banner.show()
//                    }
                }
            } catch let error as NSError {
                log.error(error)
            }
        }
    }
    
    func eventAlreadyExist(u_hash: String) -> Bool {
        for item in self.allevents {
            if item.eventIdentifier == u_hash {
                return true
            }
        }
        return false
    }
    
    func getEvents() {
        let suiteDefault = UserDefaults.init(suiteName: groupIdentifier)
        let code = suiteDefault!.integer(forKey: "code")
        let email = suiteDefault?.value(forKey: "email") as! String?
        Alamofire.request(backendUrl + "/events/getEvents?code=" + String(describing: code)).responseString { (response) in
            guard (response.result.value != nil) else {
                log.error(response)
                DispatchQueue.main.async {
                    let banner = NotificationBanner(title: "Get Remote Events Fail", subtitle: "Fatal Server Error", style: .danger)
                    banner.show()
                }
                return
            }
            let responseData = response.result.value!
            do {
                let responseJson = try JSON(data: responseData.data(using: String.Encoding.utf8)!)
                if responseJson["code"] == 0 {
                    for eventInfo in responseJson["data"].arrayValue {
                        self.eventStore.requestAccess(to: .event, completion: { (granted, error) in
                            if granted && (error == nil) {
                                var exist = false
                                for (_, hashMap):(String, JSON) in eventInfo["hashMapList"] {
                                    let u_hash = hashMap["u_hash"].stringValue
                                    if hashMap["u_mail"].stringValue == email && self.eventAlreadyExist(u_hash: u_hash) {
                                        exist = true
                                    }
                                }
                                if exist == false {
                                    let event = EKEvent(eventStore: self.eventStore)
                                    event.title = eventInfo["title"].string
//                                    event.location = eventInfo["location"].string
                                    
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "yyyy-MM-d HH:mm"
                                    event.isAllDay = eventInfo["allDay"] == 1
                                    event.startDate = dateFormatter.date(from: eventInfo["startTime"].stringValue)
                                    event.endDate = dateFormatter.date(from: eventInfo["endTime"].stringValue)
                                    
                                    event.timeZone = TimeZone(identifier: TimeZone.knownTimeZoneIdentifiers.filter { $0.contains(eventInfo["timeZone"].stringValue) }.first ?? "")
//                                    print(TimeZone.knownTimeZoneIdentifiers.filter { $0.contains(eventInfo["timeZone"].stringValue) }.first!)
//                                    print(event.timeZone)
                                    
                                    event.url = URL(string: eventInfo["url"].stringValue)
                                    event.notes = eventInfo["notes"].stringValue
                                    
                                    event.calendar = self.iOSCalendar
                                    do {
                                        try self.eventStore.save(event, span: .thisEvent, commit: true)
                                        self.postEventSaved(email: email!, u_hash: event.eventIdentifier, id: eventInfo["id"].intValue)
                                        self.updateActivity()
                                        var activityCalendar = NSCalendar.current
                                        activityCalendar.timeZone = TimeZone.current
                                        let startToday = activityCalendar.startOfDay(for: NSDate() as Date)
                                        self.updateTodayActivity(startDay: startToday as Date)
                                    } catch let error {
                                        log.error(error)
                                    }
                                }
                            }
                        })
                    }
                }
            } catch let error {
                log.error(error)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if calendarView.frame == .zero {
            calendarView.frame = CGRect(
                x: 0,
                y: weekDaysView.frame.maxY,
                width: view.frame.width,
                height: view.frame.height * 0.4
            )
            calendarView.setup()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showevent") {
            let viewcontroller = segue.destination as! EventDetailViewController
            viewcontroller.event = allevents[(sender as! IndexPath).item]
        }
    }
}

extension ActivityViewController: VAMonthHeaderViewDelegate {
    
    func didTapNextMonth() {
        calendarView.nextMonth()
    }
    
    func didTapPreviousMonth() {
        calendarView.previousMonth()
    }
    
    func didTapAdd() {
        self.performSegue(withIdentifier: "addevent", sender: nil)
    }
}

extension ActivityViewController: VAMonthViewAppearanceDelegate {
    
    func leftInset() -> CGFloat {
        return 10.0
    }
    
    func rightInset() -> CGFloat {
        return 10.0
    }
    
    func verticalMonthTitleFont() -> UIFont {
        return UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    
    func verticalMonthTitleColor() -> UIColor {
        return .black
    }
    
    func verticalCurrentMonthTitleColor() -> UIColor {
        return .red
    }
    
}

extension ActivityViewController: VADayViewAppearanceDelegate {
    
    func textColor(for state: VADayState) -> UIColor {
        switch state {
        case .out:
            return UIColor(red: 214 / 255, green: 214 / 255, blue: 219 / 255, alpha: 1.0)
        case .selected:
            return .white
        case .unavailable:
            return .lightGray
        default:
            return .black
        }
    }
    
    func textBackgroundColor(for state: VADayState) -> UIColor {
        switch state {
        case .selected:
            return .red
        default:
            return .clear
        }
    }
    
    func shape() -> VADayShape {
        return .circle
    }
    
    func dotBottomVerticalOffset(for state: VADayState) -> CGFloat {
        switch state {
        case .selected:
            return 2
        default:
            return -7
        }
    }
    
}

extension ActivityViewController: VACalendarViewDelegate {
    
    func selectedDates(_ dates: [Date]) {
        calendarView.startDate = dates.last ?? Date()
        if dates.count > 0 {
            updateTodayActivity(startDay: dates[0])
        }
    }
    
}

extension ActivityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nowevents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activity") as! ActivityCell
        let event = nowevents[indexPath.row]
        cell.setActivity(title: event.title, location: event.location, time: event.startDate)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        self.performSegue(withIdentifier: "showevent", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteEvent(indexPath: indexPath)
        }
    }
}
