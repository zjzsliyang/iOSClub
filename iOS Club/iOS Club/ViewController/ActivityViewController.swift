//
//  ActivityViewController.swift
//  iOS Club
//
//  Created by Yang Li on 2018/9/21.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit
import EventKit
import VACalendar
import NotificationBannerSwift

class ActivityViewController: UIViewController {
    
    var events = [EKEvent]()
    @IBOutlet weak var activityTableView: UITableView!
    
    @IBOutlet weak var monthHeaderView: VAMonthHeaderView! {
        didSet {
            let appereance = VAMonthHeaderViewAppearance(
                previousButtonImage: #imageLiteral(resourceName: "previous"),
                nextButtonImage: #imageLiteral(resourceName: "next"),
                dateFormat: "LLLL"
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
        
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { (granted, error) in
            if granted && (error == nil) {
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

                let oneMonthAgo = NSDate(timeIntervalSinceNow: -30*24*3600)
                let oneMonthAfter = NSDate(timeIntervalSinceNow: +30*24*3600)
                
                let predicate = eventStore.predicateForEvents(withStart: oneMonthAgo as Date, end: oneMonthAfter as Date, calendars: [iOSCalendar!])
                
                self.events = eventStore.events(matching: predicate)
                print(self.events[0].location)
                print(self.events[1].location)
                
                for event in self.events {
                    DispatchQueue.main.async {
                        self.calendarView.setSupplementaries([
                            (event.startDate!, [VADaySupplementary.bottomDots([.red])]),
                            ])
                        
                        self.activityTableView.reloadData()
                    }
                }
            }
        }

        view.addSubview(calendarView)
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
}

extension ActivityViewController: VAMonthHeaderViewDelegate {
    
    func didTapNextMonth() {
        calendarView.nextMonth()
    }
    
    func didTapPreviousMonth() {
        calendarView.previousMonth()
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
        log.debug("[ACTIVITY]: " + String(describing: dates))
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
        
}
