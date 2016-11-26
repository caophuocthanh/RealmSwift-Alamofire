//
//  UserModel.swift
//  RealmManager
//
//  Created by Cao Phuoc Thanh on 10/28/16.
//  Copyright © 2016 Cao Phuoc Thanh. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class UserModel: BaseModel {
    
    dynamic var nickname    : String   = ""
    dynamic var slug        : String   = ""
    dynamic var facebook_id : String   = ""
    dynamic var email       : String? = nil
    dynamic var avatar      : FileModel?
    dynamic var cover       : FileModel?
    dynamic var record_count: Int = 0
    dynamic var listen_count: Int = 0
    
    override func mapping(map: Map) {
        super.mapping(map)
        
        nickname <- map["nickname"]
        slug <- map["slug"]
        facebook_id <- map["facebook_id"]
        email <- map["email"]
        avatar <- map["avatar"]
        cover <- map["cover"]
        record_count <- map["record_count"]
        listen_count <- map["listen_count"]
    }
}
