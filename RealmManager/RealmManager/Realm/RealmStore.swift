//
//  RealmStore.swift
//  RealmStore
//
//  Created by Cao Phuoc Thanh on 10/15/16.
//  Copyright © 2016 Cao Phuoc Thanh. All rights reserved.
//

import UIKit
import RealmSwift

public typealias RealmStoreNotificationToken = NotificationToken

class RealmStore {
    
    /// new realm
    static let store = try! Realm()
    
    /**
     Add object(BaseModel) to store
     
     - parameter model: object (BaseModel)
     */
    static func add(model: Object) {
        try! RealmStore.write {
            RealmStore.store.add(model, update: true)
        }
    }
    
    /**
     Get all object with object type
     
     - parameter type: Object Type
     
     - returns: List Model Result (BaseModel)
     */
    static func models<T: Object>(type: T.Type) -> Results<T> {
        return  RealmStore.store.objects(T)
    }
    
    /**
     Get object with id (primary key)
     
     - parameter type: Object type
     - parameter id:   id (primary key)
     
     - returns: Object (BaseModel)
     */
    static func model<T: Object>(type: T.Type, id: Int) -> T? {
        if let model:T = RealmStore.store.objects(T).filter("id == \(id)").sorted("created_at", ascending: false).first {
            return  model
        }
        return nil
    }
    
    /**
     Change value of object in block
     
     - parameter block: block()
     
     - throws:
     */
    static func write(@noescape block: (() throws -> Void)) throws {
        RealmStore.store.beginWrite()
        try block()
        try! RealmStore.store.commitWrite()
    }
    
    /**
     Delete object (BaseModel)
     
     - parameter model: object (BaseModel)
     */
    static func delete(model: BaseModel) {
        try! RealmStore.write {
            RealmStore.store.delete(model)
        }
    }
    
}
