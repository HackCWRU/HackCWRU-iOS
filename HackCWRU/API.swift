//
//  API.swift
//  HackCWRU
//
//  Created by Jack on 1/2/17.
//  Copyright © 2017 Hacker Society. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


struct API {
    
    enum Environment {
        case development
        case production(host: String)
        
        func host() -> String {
            switch self {
            case .development:
                return "http://localhost:3000"
            case .production(let host):
                return host
            }
        }
    }
    
    struct Manager {
        
        let environment: Environment = .production(host: "https://hack-cwru.com")
        let version = "v1"
        
        var host: String {
            return environment.host()
        }
        
        var baseURL: String {
            return [host, "api", version].joined(separator: "/")
        }
        
        func eventsURL(id: String? = nil) -> String {
            if let id = id {
                return [baseURL, "event", id].joined(separator: "/")
            } else {
                return [baseURL, "events"].joined(separator: "/")
            }
        }
        
        func mapsURL() -> String {
            return [baseURL, "maps"].joined(separator: "/")
        }
        
        func announcementsURL() -> String {
            return [baseURL, "announcements"].joined(separator: "/")
        }
        
        func notificationsURL(deviceToken: String) -> String {
            return [baseURL, "notifications", "register", deviceToken].joined(separator: "/")
        }
        
    }
    
    static let manager = Manager()
    
    static func getAllEvents(completion: @escaping ([Event]?, Bool) -> Void) {
        let url = manager.eventsURL()
        let params = ["apikey": APIKeys.hackcwru]
        
        Alamofire.request(url, method: .get, parameters: params).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var events = [Event]()
                
                for (_, event) in json["events"] {
                    events.insert(Event.insertObject(json: event), at: 0)
                }
                
                completion(events, true)
                
            case .failure(let error):
                print(error)
                completion(nil, false)
            }
        }
    }
    
    static func getMap(for location: String, completion: @escaping (Map?) -> Void) {
        let url = manager.mapsURL()
        
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                for (_, mapJSON) in json["maps"] {
                    let map = Map(json: mapJSON)
                    
                    if map.location == location {
                        completion(map)
                    }
                }
                
                completion(nil)
                
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
    
    static func getAllAnnouncements(completion: @escaping ([Announcement]?, Bool) -> Void) {
        let url = manager.announcementsURL()
        let params = ["apikey": APIKeys.hackcwru]
        
        Alamofire.request(url, method: .get, parameters: params).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var announcements = [Announcement]()
                
                for (_, announcement) in json["announcements"] {
                    announcements.insert(Announcement.insertObject(json: announcement), at: 0)
                }
                
                completion(announcements, true)
                
            case .failure(let error):
                print(error)
                completion(nil, false)
            }
        }
        
    }
    
    static func registerDeviceForPushNotifications(deviceToken: String) {
        let url = manager.notificationsURL(deviceToken: deviceToken)
        let params = [
            "apikey": APIKeys.hackcwru,
            "deviceToken": deviceToken,
            "os": "ios"
        ]
        
        Alamofire.request(url, method: .post, parameters: params).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
