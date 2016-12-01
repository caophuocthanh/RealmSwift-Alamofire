//
//  DataSource.swift
//  RealmManager
//
//  Created by Cao Phuoc Thanh on 11/11/16.
//  Copyright © 2016 Cao Phuoc Thanh. All rights reserved.
//

import UIKit


// MARK: - Authenticate
class DataSource {
    
    static func authenticate(facebookId: String) -> APIDataSouce {
        let dataSource: APIDataSouce = APIDataSouce()
        dataSource.apiURL = Configuration.API + Configuration.APP_VERSION + Configuration.APIEndPoint.LOGIN
        dataSource.parameters = ["facebook_id": "\(facebookId)"]
        dataSource.method = .POST
        dataSource.identifier = "LOGIN"
        return dataSource
    }
}


// MARK: - Song Data Source
extension DataSource {
    
    class Songs {
        
        static func findByArtistId(id: Int) -> APIDataSouce {
            let dataSource: APIDataSouce = APIDataSouce()
            dataSource.apiURL = Configuration.API + Configuration.APP_VERSION + Configuration.APIEndPoint.FIND_SONGS_BY_ARTIST_ID + "\(id)"
            dataSource.method = .GET
            dataSource.identifier = "FIND_SONGS_BY_ARTIST_ID_" + String(id)
            return dataSource
        }
    }
}