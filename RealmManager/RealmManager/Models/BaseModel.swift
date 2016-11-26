//
//  BaseModel.swift
//  RealmManager
//
//  Created by Cao Phuoc Thanh on 10/15/16.
//  Copyright © 2016 Cao Phuoc Thanh. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

public enum ObjectChanged {
    case Initial
    case Update
    case Delete
    case Error(NSError)
}

/// BaseModel
class BaseModel: Object {
    
    dynamic var id = 0
    dynamic var created_at  : String?
    dynamic var updated_at  : String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func add() {
        print("ADD OBJECT:", self)
        RealmStore.add(self)
    }
    
    func map<T: BaseModel>(type: T.Type, value: AnyObject) -> T? {
        if let value: [String : AnyObject] = value as? [String : AnyObject] {
            
            //TODO: FUCK
            
            let genneric = type.init()
            if genneric.isKindOfClass(SongModel) {
                return SongModel(value: value) as? T
            } else if genneric.isKindOfClass(UserModel) {
                return UserModel(value: value) as? T
            }
            
            //TODO: FUCK
            return nil
        }
        return nil
    }
    
    func changed<T: BaseModel>(type: T.Type, block: (_: T?, _: ObjectChanged) -> Void) ->
        NotificationToken {
            
            let data = RealmStore.models(T).filter("id == \(self.id)")
            return data._addNotificationBlock({ (changes) in
                switch changes {
                case .Initial(let result):
                    block(result.first, ObjectChanged.Initial)
                case .Update(let result, deletions: let deletions, insertions: _, modifications: let modifications):
                    if deletions.count > 0 {
                        block(result.first, ObjectChanged.Delete)
                    } else if modifications.count > 0 {
                        block(result.first, ObjectChanged.Update)
                    } else {
                        block(nil, ObjectChanged.Initial)
                        print("FUCK GUYS...")
                    }
                case .Error(let error):
                    block(nil, ObjectChanged.Error(error))
                }
            })
    }
}

extension BaseModel {
    
    class func object<T: Object where T: BaseModel>(type: T.Type, id: Int) -> T? {
        return RealmStore.models(T).filter("id == \(id)").first
    }
}
