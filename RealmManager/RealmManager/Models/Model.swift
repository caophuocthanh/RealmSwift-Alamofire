//
//  SonModel.swift
//  RealmManager
//
//  Created by Cao Phuoc Thanh on 11/10/16.
//  Copyright © 2016 Cao Phuoc Thanh. All rights reserved.
//

import UIKit
import RealmSwift

class Model: Object {
    
    dynamic var identifier: String!
    dynamic var id: Int = 0
    dynamic var kindModel: String = BaseModel.className()
    dynamic var index: Int = 0
    
    override static func primaryKey() -> String? {
        return "identifier"
    }
    
    func initData<T: BaseModel>(id: Int,_ kindModel: T.Type, index: Int) {
        self.identifier = kindModel.className() + "_" + String(id)
        self.id = id
        self.kindModel = kindModel.className()
        self.index = index
    }
    
    func createId<T: BaseModel>(type: T.Type, id: Int) -> String {
        return type.className() + "_" + String(id)
    }
}
