//
//  Announcement.swift
//  HackCWRU
//
//  Created by Jack on 1/6/17.
//  Copyright © 2017 Hacker Society. All rights reserved.
//

import CoreData
import SwiftyJSON


public final class Announcement: ManagedObject, Validatable {
    
    // MARK: - Properties
    
    @NSManaged public private(set) var id: String
    @NSManaged public              var title: String
    @NSManaged public              var message: String
    @NSManaged public              var updatedAt: String
    
    var sentTimestamp: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.date(from: updatedAt)!
        
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        
        let dayOfWeek = Calendar.current.component(.weekday, from: date)
        let weekdayLabel = dateFormatter.shortWeekdaySymbols[dayOfWeek]
        
        return weekdayLabel + " " + timeFormatter.string(from: date)
    }
    
    
    // MARK: - "Intializers"
    
    static func insertObject(json: JSON?) -> Announcement {
        let announcement: Announcement = AppDelegate.moc.insertObject()
        
        if let json = json {
            announcement.id = json["_id"].string ?? ""
            announcement.title = json["title"].string ?? ""
            announcement.message = json["message"].string ?? ""
            announcement.updatedAt = json["updatedAt"].string ?? ""
        }
        
        return announcement
    }
    
    
    // MARK: - JSON Serialization
    
    func json() -> JSON {
        return [
            "_id": id,
            "title": title,
            "message": message,
        ]
    }
    
}


extension Announcement: ManagedObjectType {
    
    public static var entityName: String {
        return "Announcement"
    }
    
}
