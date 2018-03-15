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
    func upvote(_: inout Alarm?, _: (() -> Void)?)
    func downvote(_: inout Alarm?, _: (() -> Void)?)
}

// TODO: Use JSON Codable to deserialize the modesl from JSON.
// https://benscheirman.com/2017/06/swift-json/

extension Bellbird {
    
    func baseUrl() -> URL {
        guard let url = URL(string: "https://bellbird.joinhandshake-internal.com/alarms.json") else {
            return URL(string: "")!
        }
        return url
    }
    
    func alarms(from value: Data) -> [Alarm] {
        let decoder = JSONDecoder()
        if let alarms = try? decoder.decode([BellbirdAlarm].self, from: value) {
            return alarms
        }
        
        return []
    }
    
    func getAlarms(success: @escaping ([Alarm]) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: baseUrl()) { (data, response, error) in
            guard let data = data else { return }
            let allAlarms = self.alarms(from: data)
            
            DispatchQueue.main.async(execute: { () -> Void in
                success(allAlarms)
            })
        }
        dataTask.resume()
    }
    
    func upvote(_ value: inout Alarm?, _ completion: (() -> Void)?) {
        value?.votes? += 1
        sendVote(value, completion: completion)
    }
    
    func downvote(_ value: inout Alarm?, _ completion: (() -> Void)?) {
        value?.votes? -= 1
        sendVote(value, completion: completion)
    }
    
    private func sendVote(_ value: Alarm?, completion: (() -> Void)?) {
        let dataTask = URLSession.shared.dataTask(with: baseUrl()) { (data, response, error) in
            DispatchQueue.main.async(execute: { () -> Void in
                completion?()
            })
        }
        dataTask.resume()
    }
    
    /*
    // Thanks! https://medium.com/@sdrzn/networking-and-persistence-with-json-in-swift-4-part-2-e4f35a606141
    func submitPost(post: Alarm, completion:((Error?) -> Void)?) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "jsonplaceholder.typicode.com"
        urlComponents.path = "/posts"
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        
        // Specify this request as being a POST method
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        // Make sure that we include headers specifying that our request's HTTP body
        // will be JSON encoded
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        
        // Now let's encode out Post struct into JSON data...
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(post)
            // ... and set our request's HTTP body
            request.httpBody = jsonData
            print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
        } catch {
            completion?(error)
        }
        
        // Create and run a URLSession data task with our JSON encoded POST request
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                completion?(responseError!)
                return
            }
            
            // APIs usually respond with the data you just sent in your POST request
            if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
                print("response: ", utf8Representation)
            } else {
                print("no readable data received in response")
            }
        }
        task.resume()
    }
 */
}

class BellbirdAPI: Bellbird {
    static let instance: Bellbird = BellbirdAPI()
}
