//
//  BellbirdAPI.swift
//  Bellbird
//
//  Created by Blake Barrett on 3/15/18.
//  Copyright © 2018 Handshake. All rights reserved.
//

import Foundation

protocol Bellbird {
    func getAlarms(success : @escaping ([Alarm]) -> Void)
    func upvote(_: Alarm)
}

// TODO: Use JSON Codable to deserialize the modesl from JSON.
// https://benscheirman.com/2017/06/swift-json/

extension Bellbird {
    
    func getBaseUrl() -> URL? {
        return URL(string: "https://bellbird.joinhandshake-internal.com/alarms.json")
    }
    
    func alarms(from value: Data) -> [Alarm] {
        let decoder = JSONDecoder()
        if let alarms = try? decoder.decode([BellbirdAlarm].self, from: value) {
            return alarms
        }
        
        return []
    }
    
    func getAlarms(success: @escaping ([Alarm]) -> Void) {
        guard let url = getBaseUrl() else { return }
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            let allalarms = self.alarms(from: data)
            
            DispatchQueue.main.async(execute: { () -> Void in
                success(allalarms)
            })
        }
        dataTask.resume()
    }
    
    func upvote(_: Alarm) {
        
    }
}

public class API: Bellbird {
    required public init() {
        
    }
}
