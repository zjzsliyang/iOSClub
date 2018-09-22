//
//  ActivityViewController.swift
//  iOS Club
//
//  Created by Yang Li on 2018/9/21.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit
import VACalendar

class ActivityViewController: UIViewController {
    
    @IBOutlet weak var eventView: UIImageView!
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
        calendarView.selectionStyle = .multi
        calendarView.monthDelegate = monthHeaderView
        calendarView.dayViewAppearanceDelegate = self
        calendarView.monthViewAppearanceDelegate = self
        calendarView.calendarDelegate = self
        calendarView.scrollDirection = .horizontal
        calendarView.setSupplementaries([
            (Date().addingTimeInterval(-(60 * 60 * 70)), [VADaySupplementary.bottomDots([.red, .magenta])]),
            (Date().addingTimeInterval((60 * 60 * 110)), [VADaySupplementary.bottomDots([.red])]),
            (Date().addingTimeInterval((60 * 60 * 370)), [VADaySupplementary.bottomDots([.blue, .darkGray])]),
            (Date().addingTimeInterval((60 * 60 * 430)), [VADaySupplementary.bottomDots([.orange, .purple, .cyan])])
            ])
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
        print(dates)
        if dates.count > 1 {
            print(dates[1].timeIntervalSince1970)
        }
        for date in dates {
            if date.timeIntervalSince1970 == 1535414400.0 {
                eventView.image = UIImage(named: "event")
                return
            }
        }
        eventView.image = nil
    }
    
}
