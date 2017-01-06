//
//  Colors.swift
//  HackCWRU
//
//  Created by Jack on 1/6/17.
//  Copyright © 2017 Hacker Society. All rights reserved.
//

import UIKit

struct Colors {
    
    // MARK: - Color Text
    
    static let blueLine = UIColor(hex: 0x0F5D8D)
    static let uptownBlue = UIColor(hex: 0x023251)
    static let steelyardGray = UIColor(hex: 0x53595A)
    static let sludgeBlack = UIColor.black
    
    
    // MARK: - Black Text
    
    static let septemberSnow = UIColor.white
    static let towerCity = UIColor(hex: 0xE3E8EF)
    static let clevelandSky = UIColor(hex: 0xAFB9BC)
    
    
    // MARK: - Conditional Whit Text
    
    static let edgewaterBlue = UIColor(hex: 0x1371AC)
    
}


extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex:Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }

}
