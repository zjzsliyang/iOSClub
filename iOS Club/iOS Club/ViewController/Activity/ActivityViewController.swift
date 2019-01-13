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
    
    var events = [EKEvent]()
    var nowids = [Int]()
    var activitiesEvents = [String: String]()
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
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
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
        
        let suiteDefault = UserDefaults.init(suiteName: groupIdentifier)
        let map = suiteDefault?.object(forKey: "activities")
        if map != nil {
            activitiesEvents = map as! [String : String]
        }
        
        getEvents()
        
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
    
    func updateActivity() {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { (granted, error) in
            if granted && (error == nil) {
                let iOSCalendar = self.getCalendar(eventStore: eventStore)
                
                let oneMonthAgo = NSDate(timeIntervalSinceNow: -31*24*3600)
                let oneMonthAfter = NSDate(timeIntervalSinceNow: +31*24*3600)
                
                let predicate = eventStore.predicateForEvents(withStart: oneMonthAgo as Date, end: oneMonthAfter as Date, calendars: [iOSCalendar!])
                
                self.events = eventStore.events(matching: predicate)
                log.debug(self.events)
                
                DispatchQueue.main.async {
                    for event in self.events {
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
        let suiteDefault = UserDefaults.init(suiteName: groupIdentifier)
        let code = suiteDefault!.integer(forKey: "code")
        let userPrivilege = suiteDefault!.integer(forKey: "user_privilege")
        
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { (granted, error) in
            if granted && (error == nil) {
                let iOSCalendar = self.getCalendar(eventStore: eventStore)
                
                let oneMonthAgo = NSDate(timeIntervalSinceNow: -31*24*3600)
                let oneMonthAfter = NSDate(timeIntervalSinceNow: +31*24*3600)
                let predicate = eventStore.predicateForEvents(withStart: oneMonthAgo as Date, end: oneMonthAfter as Date, calendars: [iOSCalendar!])
                self.events = eventStore.events(matching: predicate)
                
                let event = self.events[indexPath.item]
                let ids = ((self.activitiesEvents as NSDictionary).allKeys(for: event.eventIdentifier) as! [String])
                if ids.count > 0 {
                    let eventParameters: Parameters = ["id": ids[0],
                                                       "code": code,
                                                       "event_privilege": 1,
                                                       "user_privilege": userPrivilege]
                    Alamofire.request(backendUrl + "/events/delete", method: .post, parameters: eventParameters, encoding: JSONEncoding.default).responseString { (response) in
                        
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
                                self.events.remove(at: indexPath.item)
                                self.getEvents()
                                self.activityTableView.reloadData()
                                let banner = NotificationBanner(title: "Delete Success", subtitle: "delete event titled " + event.title, style: .success)
                                banner.show()
                            }
                        } catch let error as NSError {
                            log.error(error)
                        }
                    }
                }
                
            }
        }
    }
    
    func getEvents() {
        let suiteDefault = UserDefaults.init(suiteName: groupIdentifier)
        let code = suiteDefault!.integer(forKey: "code")
        Alamofire.request(backendUrl + "/events/getEvents?code=" + String(describing: code)).responseString { (response) in
            guard (response.result.value != nil) else {
                log.error(response)
                DispatchQueue.main.async {
                    let banner = NotificationBanner(title: "Get Events Fail", subtitle: "Fatal Server Error", style: .danger)
                    banner.show()
                }
                return
            }
            let responseData = response.result.value!
            do {
                let responseJson = try JSON(data: responseData.data(using: String.Encoding.utf8)!)
                if responseJson["code"] == 0 {
                    for eventInfo in responseJson["data"].arrayValue {
                        let eventStore = EKEventStore()
                        eventStore.requestAccess(to: .event, completion: { (granted, error) in
                            if granted && (error == nil) {
                                let event = EKEvent(eventStore: eventStore)
                                event.title = eventInfo["title"].string
                                event.location = eventInfo["location"].string
                                
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-d HH:mm"
                                event.isAllDay = eventInfo["allDay"] == 1
                                event.startDate = dateFormatter.date(from: eventInfo["startTime"].stringValue)
                                event.endDate = dateFormatter.date(from: eventInfo["endTime"].stringValue)
                                
                                event.timeZone = TimeZone(identifier: TimeZone.knownTimeZoneIdentifiers.filter { $0.contains(eventInfo["timeZone"].stringValue) }.first ?? "")
                                
                                event.url = URL(string: eventInfo["url"].stringValue)
                                event.notes = eventInfo["notes"].stringValue

                                event.calendar = self.getCalendar(eventStore: eventStore)
                                
                                do {
                                    if !self.activitiesEvents.keys.contains(String(describing: eventInfo["id"])) {
                                        try eventStore.save(event, span: .thisEvent, commit: true)
                                        self.activitiesEvents[String(describing: eventInfo["id"])] = event.eventIdentifier
                                        self.updateActivity()
                                        suiteDefault?.set(self.activitiesEvents, forKey: "activities")
                                        suiteDefault?.synchronize()
                                        DispatchQueue.main.async {
                                            for event in self.events {
                                                self.calendarView.setSupplementaries([
                                                    (event.startDate!, [VADaySupplementary.bottomDots([.red])]),
                                                    ])
                                                log.debug(event)
                                            }
                                            self.activityTableView.reloadData()
                                        }
                                    }
                                } catch let error as NSError {
                                    log.error(error)
                                }
                            }
                        })
                    }
                }
            } catch let error as NSError {
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
            viewcontroller.event = events[(sender as! IndexPath).item]
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
        log.debug(dates)
    }
    
}

extension ActivityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activity") as! ActivityCell
        let event = events[indexPath.row]
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
