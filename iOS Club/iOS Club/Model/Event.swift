//
//  Event.swift
//  Student Club
//
//  Created by Yang Li on 2018/12/28.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import Foundation

struct Event: Decodable {
    let title: String
    let location: String
    
    let allDay: String
    let startTime: String
    let endTime: String
    let timeZone: String
    
    let repeatTime: String
    let invitees: String
    let alerts: [String]
    
    let url: String
    let notes: String
}
