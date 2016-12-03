//
//  ZModel.swift
//  RealmManager
//
//  Created by Cao Phuoc Thanh on 10/15/16.
//  Copyright © 2016 Cao Phuoc Thanh. All rights reserved.
//

import UIKit
import RealmSwift
import Realm
import ObjectMapper


public enum ObjectChanged {
    case Initial
    case Update
    case Delete
    case Error(NSError)
}


class ZModel: Object, Mappable {
    
    dynamic var id = 0
    dynamic var created_at  : String?
    dynamic var updated_at  : String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required init() { super.init() }
    required init?(_ map: Map) { super.init() }
    required init(value: AnyObject, schema: RLMSchema) { super.init(value: value, schema: schema) }
    required init(realm: RLMRealm, schema: RLMObjectSchema) { super.init(realm: realm, schema: schema) }
    
    func mapping(map: Map) {
        id <- map["id"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
    }
    
    func add() {
        ZRealmStore.add(self)
    }
    
    func map<T: ZModel>(type: T.Type, value: AnyObject) -> T? {
        if let value: [String : AnyObject] = value as? [String : AnyObject] {
            return Mapper<T>().map(value)
        }
        return nil
    }
    
    func changed<T: ZModel>(type: T.Type, block: (_: T?, _: ObjectChanged) -> Void) ->
        NotificationToken {
            
            let data = ZRealmStore.models(T).filter("id == \(self.id)")
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

extension ZModel {
    
    class func object<T: Object where T: ZModel>(type: T.Type, id: Int) -> T? {
        return ZRealmStore.models(T).filter("id == \(id)").first
    }
}
