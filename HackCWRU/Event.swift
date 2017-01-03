//
//  Event.swift
//  HackCWRU
//
//  Created by Jack on 1/2/17.
//  Copyright © 2017 Hacker Society. All rights reserved.
//

import CoreData
import SwiftyJSON


public final class Event: ManagedObject {
    
    // MARK: - Properties
    
    @NSManaged public private(set) var id: String
    @NSManaged public              var name: String
    @NSManaged public              var desc: String
    @NSManaged public              var startTime: String
    @NSManaged public              var endTime: String
    @NSManaged public              var location: String
    
    
    // MARK: - "Intializers"
    
    static func insertObject(json: JSON?) -> Event {
        let event: Event = AppDelegate.moc.insertObject()
        
        if let json = json {
            event.id = json["_id"].string!
            event.name = json["name"].string!
            event.desc = json["description"].string!
            event.startTime = json["startTime"].string!
            event.endTime = json["endTime"].string!
            event.location = json["location"].string!
        }
        
        return event
    }
    
    
    // MARK: - JSON Serialization
    
    func json() -> JSON {
        return [
            "_id": id,
            "name": name,
            "description": desc,
            "startTime": startTime,
            "endTime": endTime,
            "location": location
        ]
    }
}


extension Event: ManagedObjectType {
    
    public static var entityName: String {
        return "Event"
    }
    
}
