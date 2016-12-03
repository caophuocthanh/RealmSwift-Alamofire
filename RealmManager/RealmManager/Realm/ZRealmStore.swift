//
//  ZRealmStore.swift
//  ZRealmStore
//
//  Created by Cao Phuoc Thanh on 10/15/16.
//  Copyright © 2016 Cao Phuoc Thanh. All rights reserved.
//

import UIKit
import RealmSwift

public typealias ZRealmStoreNotificationToken = NotificationToken

class ZRealmStore {
    
    /// new realm
    static let store = try! Realm()
    
    /**
     Add object(ZModel) to store
     
     - parameter model: object (ZModel)
     */
    static func add(model: Object) {
        try! ZRealmStore.write {
            ZRealmStore.store.add(model, update: true)
        }
    }
    
    /**
     Get all object with object type
     
     - parameter type: Object Type
     
     - returns: List Model Result (ZModel)
     */
    static func models<T: Object>(type: T.Type) -> Results<T> {
        return  ZRealmStore.store.objects(T)
    }
    
    /**
     Get object with id (primary key)
     
     - parameter type: Object type
     - parameter id:   id (primary key)
     
     - returns: Object (ZModel)
     */
    static func model<T: Object>(type: T.Type, id: Int) -> T? {
        if let model:T = ZRealmStore.store.objects(T).filter("id == \(id)").sorted("created_at", ascending: false).first {
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
        ZRealmStore.store.beginWrite()
        try block()
        try! ZRealmStore.store.commitWrite()
    }
    
    /**
     Delete object (ZModel)
     
     - parameter model: object (ZModel)
     */
    static func delete(model: ZModel) {
        try! ZRealmStore.write {
            ZRealmStore.store.delete(model)
        }
    }
    
}
