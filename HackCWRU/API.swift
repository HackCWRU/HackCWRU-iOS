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
        
        func notificationsURL() -> String {
            return [baseURL, "notification", "recipients"].joined(separator: "/")
        }
        
        func mentorRequestsURL() -> String {
            return [baseURL, "mentor", "requests"].joined(separator: "/")
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
    
    static func getMaps(for locations: [String], completion: @escaping ([Map]?) -> Void) {
        let url = manager.mapsURL()
        
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var maps = [Map]()
                
                for location in locations {
                    for (_, mapJSON) in json["maps"] {
                        let map = Map(json: mapJSON)
                        
                        if map.location == location {
                            maps.append(map)
                        }
                    }
                }
                
                completion(maps)
                
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
        let url = manager.notificationsURL()
        let params = [
            "apikey": APIKeys.hackcwru,
            "deviceToken": deviceToken,
            "os": "ios"
        ]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func submitMentorRequest(menteeName: String, topics: String, locationDescription: String,
                                    completion:  @escaping (MentorRequest?, Bool) -> Void) {
        guard let deviceToken = HackCWRUDefaults.deviceToken else {
            completion(nil, false)
            return
        }
        
        let url = manager.mentorRequestsURL()
        let params: [String : Any] = [
            "apikey": APIKeys.hackcwru,
            "locationDescription": locationDescription,
            "topics": topics.replacingOccurrences(of: ", ", with: ","),
            "mentee": [
                "name": menteeName,
                "deviceId": deviceToken
            ]
        ]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                dump(json)
                
                let mentorRequest = MentorRequest.insertObject(json: json)
                
                completion(mentorRequest, true)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
