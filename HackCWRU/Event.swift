//
//  Event.swift
//  HackCWRU
//
//  Created by Jack on 1/2/17.
//  Copyright © 2017 Hacker Society. All rights reserved.
//

import CoreData
import SwiftyJSON


public final class Event: ManagedObject, Validatable {
    
    // MARK: - Properties
    
    @NSManaged public private(set) var id: String
    @NSManaged public              var name: String
    @NSManaged public              var desc: String
    @NSManaged public              var startTime: String
    @NSManaged public              var endTime: String
    @NSManaged public              var location: String
    @NSManaged public              var updatedAt: String
    @NSManaged public              var isFavorite: Bool
    
    public var map: Map?
    
    var date: String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .medium
        
        return timeFormatter.string(from: startDate)
    }
    
    var timeSlot: String {
        let endDate = date(from: endTime)
        
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        
        return timeFormatter.string(from: startDate) + " - " + timeFormatter.string(from: endDate)
    }
    
    var startDate: Date {
        return date(from: startTime)
    }
    
    var favoritePreviewAction: UIPreviewAction {
        let title = isFavorite ? "Unfavorite" : "Favorite"
        
        return UIPreviewAction(title: title, style: .default) { [weak self] action, viewController in
            self?.isFavorite = !(self?.isFavorite ?? true)
            try! AppDelegate.moc.save()
        }
    }
    

    // MARK: - "Intializers"
    
    static func insertObject(json: JSON?) -> Event {
        let event: Event = AppDelegate.moc.insertObject()
        
        if let json = json {
            event.id = json["_id"].string ?? ""
            event.name = json["name"].string ?? ""
            event.desc = json["description"].string ?? ""
            event.startTime = json["startTime"].string ?? ""
            event.endTime = json["endTime"].string ?? ""
            event.location = json["location"].string ?? ""
            event.updatedAt = json["updatedAt"].string ?? ""
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
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: string)!
    }
    
}


extension Event: ManagedObjectType {
    
    public static var entityName: String {
        return "Event"
    }
    
}

extension Array where Element: Event {
    
    func groupAndSort(_ favoritesOnly: Bool = false) -> [Date: [Event]] {
        var result = [Date: [Event]]()
        var filtered = [Event]()
        
        if favoritesOnly {
            filtered = filter { event in
                return event.isFavorite
            }
        } else {
            filtered = self
        }
        
        let sortedByDate = filtered.sorted { lhs, rhs in
            return lhs.startTime < rhs.startTime
        }
        
        sortedByDate.forEach { event in
            // Eliminate the timestamp from each date.
            var eventDate = event.startDate
            let comps = Calendar.current.dateComponents([.day, .month, .year], from: eventDate)
            eventDate = Calendar.current.date(from: comps)!
            
            result[eventDate] = (result[eventDate] ?? []) + [event]
        }
        
        return result
    }
    
}
