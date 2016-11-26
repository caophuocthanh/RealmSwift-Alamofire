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
    
    class func local<T: Object where T: BaseModel >(
        type: T.Type,
        dataSource: APIDataSouce,
        complete: ((data: [T]?) -> Void)) {
        
        let _store = RealmStore.models(StoreModel.self).filter("identifier =='\(dataSource.identifier)'").first
        
        if let models = _store?.models {
            var response = [T]()
            for item in  models {
                if let model = RealmStore.models(T.self).filter("id == \(item.id)").first {
                    response.append(model)
                }
            }
            complete(data: response)
        }
        complete(data: nil)
    }
    
    class func service<T: Object where T: BaseModel >(
        type: T.Type,
        dataSource: APIDataSouce,
        complete: ((data: [T]?) -> Void)) {
        
        APIManager.request(dataSource) { (data) in
            if let data = data.data as? [AnyObject] {
                let store = StoreModel()
                store.identifier = dataSource.identifier
                var genericObjects = [T]()
                for (index, object) in data.enumerate() {
                    let genericObject = T()
                    if let obj:T = genericObject.map(type, value: object) {
                        RealmStore.add(obj)
                        genericObjects.append(obj)
                        store.addNote(type, object: obj, index: index)
                    }
                }
                store.add()
                complete(data: genericObjects)
                return
            } else if let data: AnyObject = data.data {
                let store = StoreModel()
                store.identifier = dataSource.identifier
                let genericObject = T()
                if let obj:T = genericObject.map(type, value: data) {
                    RealmStore.add(obj)
                    store.addNote(type, object: obj, index: 0)
                    complete(data: [obj])
                    return
                }
                complete(data: nil)
                return
            } else {
                complete(data: nil)
                return
            }
        }
    }
    
    class func data<T: Object where T: BaseModel >(
        type: T.Type,
        dataSource: APIDataSouce,
        local: ((data: [T]?) -> Void),
        service: ((data: [T]?) -> Void)) {
        
        StoreManager.local(type, dataSource: dataSource) { (data) in
            local(data: data)
        }
        StoreManager.service(type, dataSource: dataSource) { (data) in
            service(data: data)
        }
    }
    
}
