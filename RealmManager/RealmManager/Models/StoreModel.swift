//
//  StoreModel.swift
//  RealmManager
//
//  Created by Cao Phuoc Thanh on 11/10/16.
//  Copyright © 2016 Cao Phuoc Thanh. All rights reserved.
//

import Foundation
import RealmSwift

class StoreModel: Object {
    
    dynamic var identifier: String!
    let models = List<Model>()
    
    override static func primaryKey() -> String? {
        return "identifier"
    }
    
    func add() {
        RealmStore.add(self)
    }
    
    func addNote<T: BaseModel>(type: T.Type, object: T, index: Int) {
        let model = Model()
        model.initData(object.id, SongModel.self, index: index)
        self.models.append(model)
    }

}
