//
//  HackCWRUDefaults.swift
//  HackCWRU
//
//  Created by Jack on 4/9/17.
//  Copyright © 2017 Hacker Society. All rights reserved.
//

import Foundation

struct HackCWRUDefaults {
    
    static var deviceToken: String? {
        get {
            return UserDefaults.standard.value(forKey: #function) as? String
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: #function)
        }
    }
    
}
