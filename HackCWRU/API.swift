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
        
        let environment: Environment = .development //.production(host: "http://ec2-54-88-206-27.compute-1.amazonaws.com:3000")
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
        
    }
    
    static let manager = Manager()
    
    static func getAllEvents(completion: @escaping (_ events: [Event]) -> Void) {
        
        let url = manager.eventsURL()
        let params = ["apikey": APIKeys.hackcwru]
        
        Alamofire.request(url, method: .get, parameters: params).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var events = [Event]()
                
                for (_, event) in json {
                    events.insert(Event.insertObject(json: event), at: 0)
                }
                
                completion(events)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
}
