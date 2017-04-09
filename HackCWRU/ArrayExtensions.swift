//
//  ArrayExtensions.swift
//  HackCWRU
//
//  Created by Jack on 4/9/17.
//  Copyright © 2017 Hacker Society. All rights reserved.
//

import Foundation

extension Array where Element == String {
    
    func listFormatted() -> String {
        var formatted = first ?? ""
        
        let commasNecessary = count > 2
        let andNecessary = count > 1
        
        for (index, element) in self.enumerated() {
            if (index < count - 1 && commasNecessary) {
                formatted = formatted + ", "
            }
            
            if (index == count - 1 && andNecessary) {
                if (count == 2) {
                    formatted += " and \(element)"
                } else {
                    formatted += "and \(element)";
                }
            }
        }
        
        return formatted
    }
    
}
