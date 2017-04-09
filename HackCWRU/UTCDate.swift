//
//  UTCDate.swift
//  HackCWRU
//
//  Created by Jack on 4/9/17.
//  Copyright © 2017 Hacker Society. All rights reserved.
//

import Foundation

public struct UTCDate {
    
    static var stringFormat =  "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    
    private static var dateFormatterUTC: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = UTCDate.stringFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter
    }()
    
    private static var dateFormatterCurrent: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = UTCDate.stringFormat
        dateFormatter.timeZone = .current
        return dateFormatter
    }()
    
    
    private let date: Date
    
    public var dateForCurrentTimezone: Date {
        let dateString =  UTCDate.dateFormatterCurrent.string(from: date)
        return UTCDate.dateFormatterCurrent.date(from: dateString)!
    }
    
    public init?(string: String) {
        if let utcDate = UTCDate.dateFormatterUTC.date(from: string) {
            date = utcDate
        } else {
            return nil
        }
    }
    
}
