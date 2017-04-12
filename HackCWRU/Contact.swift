//
//  Contact.swift
//  HackCWRU
//
//  Created by Jack on 4/12/17.
//  Copyright © 2017 Hacker Society. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Contact {
    
    public let name: String
    public let phone: String
    public let groups: [String]
    
    public var callMessage: String {
        return "Call \(name)"
    }
    
    public init?(json: JSON) {
        guard let name = json["name"].string else { return nil }
        guard let phone = json["phone"].string else { return nil }
        
        self.name = name
        self.phone = phone
        self.groups = json["groups"].array?.flatMap({ $0.string }) ?? []
    }
    
    public func call() {
        if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}


extension Array where Element == Contact {
    
    public func grouped() -> [String: [Contact]] {
        var groupedContacts = [String: [Contact]]()
        
        forEach { contact in
            contact.groups.forEach { group in
                
                if groupedContacts[group] == nil {
                    groupedContacts[group] = [contact]
                } else {
                    groupedContacts[group]?.append(contact)
                }
            }
        }
        
        return groupedContacts
    }
    
}
