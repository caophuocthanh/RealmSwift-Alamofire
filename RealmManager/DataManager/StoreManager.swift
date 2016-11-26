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
        complete: ((data: [T]) -> Void)) {
        
        let _store = RealmStore.models(StoreModel.self).filter("identifier =='\(dataSource.identifier)'").first
        var response = [T]()
        
        if let models = _store?.models {
            for item in  models {
                if let model: Results<T> = RealmStore.models(T.self).filter("id == \(item.id)") {
                    response.append(model.first! as T)
                }
            }
        }
        complete(data: response)
    }
    
    class func service<T: Object where T: BaseModel >(
        type: T.Type,
        dataSource: APIDataSouce,
        complete: ((data: [AnyObject]) -> Void)) {
        
        APIManager.request(dataSource) { (data) in
            if let data = data.data as? [AnyObject] {
                complete(data: data)
            } else if let data: AnyObject = data.data {
                complete(data: [data])
            } else {
                complete(data: [])
            }
        }
    }
    
    class func data<T: Object where T: BaseModel >(
        type: T.Type,
        dataSource: APIDataSouce,
        local: ((data: [T]) -> Void),
        service: ((data: [AnyObject]) -> Void)) {
        
        StoreManager.local(type, dataSource: dataSource) { (data) in
            local(data: data)
        }
        StoreManager.service(type, dataSource: dataSource) { (data) in
            service(data: data)
        }
    }
    
}
