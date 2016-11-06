//
//  Configuration.swift
//  RealmManager
//
//  Created by Cao Phuoc Thanh on 10/28/16.
//  Copyright © 2016 Cao Phuoc Thanh. All rights reserved.
//

import Foundation
import RealmSwift

struct Configuration {
    
    static let API = "https://yosing.vn"
    
    static let APP_VERSION = "/v1"
    
    struct APIEndPoint {
        
        static let LOGIN = "/users/login"
        
        static let FIND_SONGS_BY_ARTIST_ID = "/songs/find-by-artist/"

    }

}
