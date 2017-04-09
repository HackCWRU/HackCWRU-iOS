//
//  DateExtensions.swift
//  HackCWRU
//
//  Created by Jack on 4/9/17.
//  Copyright © 2017 Hacker Society. All rights reserved.
//

import Foundation

extension Date {
    
    func dayOfWeek(using weekdaySymbols: [String] = DateFormatter().weekdaySymbols) -> String {
        let dayOfWeek = Calendar.current.component(.weekday, from: self)
        return weekdaySymbols[dayOfWeek - 1]
    }
    
}
