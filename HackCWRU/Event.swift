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
    
    
    // MARK: - "Intializers"
    
    static func insertObject(json: JSON?) -> Event {
        let event: Event = AppDelegate.moc.insertObject()
        
        if let json = json {
            event.id = json["_id"].string!
            event.name = json["name"].string!
        }
        
        return event
    }
    
    
    // MARK: - JSON Serialization
    
    func json() -> JSON {
        return [
            "_id": id,
            "name": name
        ]
    }
}


extension Event: ManagedObjectType {
    
    public static var entityName: String {
        return "Event"
    }
    
}
