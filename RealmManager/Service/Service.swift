//
//  Service.swift
//  RealmManager
//
//  Created by Cao Phuoc Thanh on 11/25/16.
//  Copyright © 2016 Cao Phuoc Thanh. All rights reserved.
//

import UIKit

class Service {
    
    class func login(facebookId: String, completion: ((user: UserModel?) -> Void)) {
        
        let dataSource: APIDataSouce = DataSource.authenticate(facebookId)
        
        APIManager.request(dataSource) { (response) in
            if let data: AnyObject = response.data {
                let user = UserModel(value: data)
                user.addStore()
                completion(user: user)
            } else {
                completion(user: nil)
            }
        }
    }
    
    
    class func getSongsByArtistId(id: Int,
                                  store: ((store: [SongModel]) -> Void),
                                  completion: ((songs: [SongModel]) -> Void)) {
        
        // GET STORE
        let dataSource: APIDataSouce = DataSource.Song.findSongsByArtistId(id)
        let _store = RealmStore.models(StoreModel.self).filter("identifier =='\(dataSource.identifier)'").first
        var response = [SongModel]()
        if let models = _store?.models {
            for item in  models {
                if let song = RealmStore.models(SongModel.self).filter("id == \(item.id)").first {
                    response.append(song)
                }
            }
        }
        store(store: response)
        
        // GET SERVICE
        APIManager.request(dataSource) { (response) in
            var songs = [SongModel]()
            if let data = response.data as? [AnyObject] {
                
                let store = StoreModel()
                store.identifier = dataSource.identifier
                for (index, object) in data.enumerate() {
                    let model = Model()
                    let song = SongModel(value: object)
                    // save song
                    song.addStore()
                    
                    model.initData(song.id, SongModel.self, index: index)
                    songs.append(song)
                    store.models.append(model)
                }
                store.addStore()
            }
            completion(songs: songs)
        }
    }
    
    
    //    class func getSongsByArtistId(id: Int, completion: ((store: StoreModel) -> Void)) {
    //
    //        let dataSource: APIDataSouce = DataSource.Song.findSongsByArtistId(id)
    //
    //        APIManager.request(dataSource) { (response) in
    //            let store = StoreModel()
    //            store.identifier = dataSource.identifier
    //
    //            if let data = response.data as? [AnyObject] {
    //                for (index, object) in data.enumerate() {
    //                    let model = Model()
    //                    let song = SongModel(value: object)
    //                    song.addStore()
    //                    model.initData(song.id, ObjectKind.Song.hashValue, index: index)
    //                    model.addStore()
    //                    store.models.append(model)
    //                }
    //            }
    //            completion(store: store)
    //        }
    //    }
}
