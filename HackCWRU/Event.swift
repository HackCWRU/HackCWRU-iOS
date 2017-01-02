//
//  Event.swift
//  HackCWRU
//
//  Created by Jack on 1/2/17.
//  Copyright © 2017 Hacker Society. All rights reserved.
//

import CoreData


public final class Event: ManagedObject {
    
    // MARK: - Properties
    
    @NSManaged public private(set) var id: String
    @NSManaged public              var name: String
    
    
    // MARK: - "Intializers"
    
    static func insertObject() -> Event {
        let event: Event = AppDelegate.moc.insertObject()
        return event
    }
    
}


extension Event: ManagedObjectType {
    
    public static var entityName: String {
        return "Event"
    }
    
}
