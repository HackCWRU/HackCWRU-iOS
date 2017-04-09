//
//  MentorRequest.swift
//  HackCWRU
//
//  Created by Jack on 4/9/17.
//  Copyright © 2017 Hacker Society. All rights reserved.
//

import CoreData
import SwiftyJSON


public final class MentorRequest: ManagedObject {
    
    // MARK: - Properties
    
    @NSManaged public private(set) var id: String
    @NSManaged public              var locationDescription: String
    @NSManaged public              var opened: String
    @NSManaged public              var status: String
    @NSManaged public              var topics: String // Comma seperated list
    
    
    // MARK: - "Intializers"
    
    static func insertObject(json: JSON?) -> MentorRequest {
        let mentorRequest: MentorRequest = AppDelegate.moc.insertObject()
        
        if let json = json {
            mentorRequest.id = json["_id"].string ?? ""
            mentorRequest.locationDescription = json["locationDescription"].string ?? ""
            mentorRequest.opened = json["meta"]["opened"].string ?? ""
            mentorRequest.status = json["status"].string ?? "open"
            mentorRequest.topics = (json["topics"].arrayObject as? [String])?.joined(separator: ",") ?? ""
        }
        
        return mentorRequest
    }
    
}


extension MentorRequest: ManagedObjectType {
    
    public static var entityName: String {
        return "MentorRequest"
    }
    
}
