//
//  Map.swift
//  HackCWRU
//
//  Created by Jack on 4/3/17.
//  Copyright © 2017 Hacker Society. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Map: NSObject {
    
    public let location: String
    public let name: String
    public let imageURL: String
    
    public init(json: JSON) {
        self.location = json["location"].string ?? ""
        self.name = json["name"].string ?? ""
        self.imageURL = json["imageURL"].string ?? ""
    }
    
    public init(location: String, name: String, imageURL: String) {
        self.location = location
        self.name = name
        self.imageURL = imageURL
    }
    
}
