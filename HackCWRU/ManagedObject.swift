//
//  ManagedObject.swift
//  HackCWRU
//
//  Created by Jack on 1/2/17.
//  Copyright © 2017 Hacker Society. All rights reserved.
//

import CoreData


public class ManagedObject: NSManagedObject {
    
}


public protocol ManagedObjectType: class {
    
    static var entityName: String { get }
    
}


extension ManagedObjectType {
    
    static func entityDescription(moc: NSManagedObjectContext) -> NSEntityDescription {
        guard let psc = AppDelegate.moc.persistentStoreCoordinator else { fatalError("PSC missing") }
        guard let entity = psc.managedObjectModel.entitiesByName[Self.entityName] else { fatalError("Entity \(Self.entityName) not found") }
        return entity
    }
    
}

extension NSManagedObjectContext {
    
    public func insertObject<T: ManagedObject>() -> T where T: ManagedObjectType {
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: T.entityName, into: self) as? T else { fatalError("Wrong object type") }
        return obj
    }
    
}
