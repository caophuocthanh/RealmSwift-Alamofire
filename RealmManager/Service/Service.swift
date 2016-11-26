//
//  Service.swift
//  RealmManager
//
//  Created by Cao Phuoc Thanh on 11/25/16.
//  Copyright © 2016 Cao Phuoc Thanh. All rights reserved.
//

import UIKit

class Service {
    
    class func login(
        facebookId: String,
        completion: ((user: UserModel?) -> Void)) {
        
        let dataSource: APIDataSouce = DataSource.authenticate(facebookId)
        
        APIManager.request(dataSource) { (response) in
            if let data: AnyObject = response.data {
                let user = UserModel(value: data)
                user.add()
                completion(user: user)
            } else {
                completion(user: nil)
            }
        }
    }
    
    
    class func getSongsByArtistId(
        id: Int,
        store: ((data: [SongModel]) -> Void),
        service: ((data: [SongModel]) -> Void)) {
        
        // Data Source
        let dataSource: APIDataSouce = DataSource.Song.findSongsByArtistId(id)
        
        // Get data
        StoreManager.data(SongModel.self, dataSource: dataSource, local: { (data) in
            store(data: data)
            }) { (data) in
                
                
                // Handle object response
                // TODO: Need improve by 'ObjectMapper' to init Genneric Object
                
                let store = StoreModel()
                store.identifier = dataSource.identifier
                var songs = [SongModel]()
                
                for (index, object) in data.enumerate() {
                    let song = SongModel(value: object)
                    song.add()
                    songs.append(song)
                    store.addNote(SongModel.self, object: song, index: index)
                }
                store.add()
                service(data: songs)
        }
        
    }
    
}
