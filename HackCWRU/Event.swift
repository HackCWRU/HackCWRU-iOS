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
    @NSManaged public              var isFavorite: Bool
    
    var date: String {
        let startDate = date(from: startTime)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .medium
        
        return timeFormatter.string(from: startDate)
    }
    
    var timeSlot: String {
        let startDate = date(from: startTime)
        let endDate = date(from: endTime)
        
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        
        return timeFormatter.string(from: startDate) + " - " + timeFormatter.string(from: endDate)
    }
    
    var weekdaySymbol: String {
        let startDate = date(from: startTime)
        let dayOfWeekIndex = Calendar.current.component(.weekday, from: startDate)
        
        return DateFormatter().weekdaySymbols[dayOfWeekIndex]
    }
    

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
        
        event.isFavorite = false
        
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
    
    
    // MARK: - Date Formatting
    
    func date(from string: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd HH:mm:ss"
        return formatter.date(from: string)!
    }
    
}


extension Event: ManagedObjectType {
    
    public static var entityName: String {
        return "Event"
    }
    
}

extension Array where Element: Event {
    
    func groupAndSort() -> [Date: [Event]] {
        var result = [Date: [Event]]()
        
        let sortedByDate = sorted { lhs, rhs in
            return lhs.startTime < rhs.startTime
        }
        
        sortedByDate.forEach { event in
            let eventDate = event.date(from: event.startTime)
            result[eventDate] = (result[eventDate] ?? []) + [event]
        }
        
        return result
    }
    
}
