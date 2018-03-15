//
//  Alarm.swift
//  Bellbird
//
//  Created by Blake Barrett on 3/15/18.
//  Copyright © 2018 Handshake. All rights reserved.
//

import Foundation

protocol Alarm {
    var id: Int { get set }
    var body: String? { get set }
    var votes: Int? { get set }
    var created_at: String { get set } // Looks to be an ISO8601 Date "2017-12-06T20:07:35.075Z",
    var updated_at: String { get set } //  "2017-12-06T20:07:35.075Z"
    
    var createdAt: Date? { get }
    var updatedAt: Date? { get }
}

class BellbirdAlarm: Alarm, Codable {
    
    var id: Int
    var body: String?
    var votes: Int?
    
    var created_at: String
    var updated_at: String
    
    var createdAt: Date?
    var updatedAt: Date?
    
    required init(with body: String) {
        id = -1
        self.body = body
        created_at = ""
        updated_at = ""
        createdAt = Date.dateFromISOString(string: created_at)
        updatedAt = Date.dateFromISOString(string: updated_at)
    }
}
