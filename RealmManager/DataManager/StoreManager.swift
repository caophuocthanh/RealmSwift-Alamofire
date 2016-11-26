//
//  StoreManager.swift
//  RealmManager
//
//  Created by Cao Phuoc Thanh on 11/11/16.
//  Copyright © 2016 Cao Phuoc Thanh. All rights reserved.
//

import UIKit
import RealmSwift

class StoreManager {
    
    class func data<T: BaseModel>(type: T.Type,
                    dataSource: APIDataSouce,
                    store: ((store: [T]) -> Void),
                    service: ((service: [SongModel]) -> Void)) {
        
        let _store = RealmStore.models(StoreModel.self).filter("identifier =='\(dataSource.identifier)'").first
        
        //print("STORE:", _store)
        
        var response = [T]()
        
        if let models = _store?.models {
            for item in  models {
                if let model: Results<T> = RealmStore.models(T.self).filter("id == \(item.id)") {
                    response.append(model.first!)
                }
            }
        }
        
        store(store: response)
        
        APIManager.request(dataSource) { (response) in
            
            var objects = [SongModel]()
            if let data = response.data as? [AnyObject] {
                
                let store = StoreModel()
                store.identifier = dataSource.identifier
                for (index, item) in data.enumerate() {
                    let model = Model()
                    let object = SongModel(value: item)
                    
                    // save song
                    object.addStore()
                    
                    model.initData(object.id, T.self, index: index)
                    objects.append(object)
                    
                    // Save store
                    store.models.append(model)
                }
                store.addStore()
            }
            service(service: objects)
            
        }
    }
    
}
