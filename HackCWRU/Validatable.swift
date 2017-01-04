//
//  Validatable.swift
//  HackCWRU
//
//  Created by Jack on 1/4/17.
//  Copyright © 2017 Hacker Society. All rights reserved.
//

import Foundation

protocol Validatable {
    
    var id: String { get }
    var updatedAt: String { get }
    
}


extension Validatable {
    
    func isOlder(than: Validatable) -> Bool {
        return updatedAt < than.updatedAt
    }
    
    func matches(other: Validatable) -> Bool {
        return id == other.id
    }
    
}


extension Validatable {
    
    func update(to: Self, updateBlock: (Self, Self) -> Void) {
        if matches(other: to) && isOlder(than: to) {
            updateBlock(self, to)
        }
        
        if let managedObject = to as? ManagedObject {
            AppDelegate.moc.delete(managedObject)
        }
    }
    
}


extension Array where Element: Validatable {
    
    typealias Save = (Element) -> Void
    typealias Update = (Element, Element) -> Void
    typealias Delete = (Element) -> Void
    
    func update(to: [Element], saveBlock: Save, updateBlock: @escaping Update, deleteBlock: Delete, completion: () -> Void) {
        let ids = Set(map { $0.id })
        let toIds = Set(to.map { $0.id })
        
        // Save the missing objects.
        let missingIds = toIds.subtracting(ids)
        let missing = to.filter { missingIds.contains($0.id) }
        missing.forEach { element in
            saveBlock(element)
        }
        
        // Update objects with changes.
        let matchingIds = toIds.intersection(ids)
        let matching = filter { matchingIds.contains($0.id) }
        matching.forEach { element in
            element.update(to: to.filter({ $0.id == element.id }).first!, updateBlock: updateBlock)
        }
        
        // Delete objects that don't exist.
        let extraneousIds = ids.subtracting(toIds)
        let extraneous = filter { extraneousIds.contains($0.id) }
        extraneous.forEach { element in
            deleteBlock(element)
        }
        
        completion()
    }
    
}
