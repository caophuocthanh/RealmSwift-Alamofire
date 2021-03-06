//
//  Service.swift
//  RealmManager
//
//  Created by Cao Phuoc Thanh on 11/25/16.
//  Copyright © 2016 Cao Phuoc Thanh. All rights reserved.
//

import UIKit

class Service {
    
    class func authenticate(
        facebookId: String,
        completion: ((user: [UserModel]) -> Void)) {
        // Data Source
        let dataSource: APIDataSouce = DataSource.authenticate(facebookId)
        // Get data
        ZStoreManager.service(UserModel.self, dataSource: dataSource) { (data) in
            completion(user: data ?? [])
        }
    }
    
    class Songs {
        
        class func findByArtistId(
            id: Int,
            store: ((data: [SongModel]) -> Void),
            service: ((data: [SongModel]) -> Void)) {
            // Data Source
            let dataSource: APIDataSouce = DataSource.Songs.findByArtistId(id)
            // Get data
            ZStoreManager.data(SongModel.self, dataSource: dataSource, local: { (data) in
                store(data: data ?? [])
            }) { (data) in
                service(data: data ?? [])
            }
        }
    }
    
}
