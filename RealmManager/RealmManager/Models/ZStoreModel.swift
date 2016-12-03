//
//  ZStoreModel.swift
//  RealmManager
//
//  Created by Cao Phuoc Thanh on 11/10/16.
//  Copyright © 2016 Cao Phuoc Thanh. All rights reserved.
//

import Foundation
import RealmSwift

class ZStoreModel: Object {
    
    dynamic var identifier: String!
    let models = List<ZSonStoreModel>()
    
    override static func primaryKey() -> String? {
        return "identifier"
    }
    
    func add() {
        ZRealmStore.add(self)
    }
    
    func addNote<T: ZModel>(type: T.Type, object: T, index: Int) {
        let model = ZSonStoreModel()
        model.initData(object.id, SongModel.self, index: index)
        self.models.append(model)
    }

}
