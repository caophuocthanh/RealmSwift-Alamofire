//
//  SingerModel.swift
//  RealmManager
//
//  Created by Cao Phuoc Thanh on 11/3/16.
//  Copyright © 2016 Cao Phuoc Thanh. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class SingerModel: ZModel {
    
    dynamic var avatar: FileModel?
    dynamic var avatar_id: Int = 0
    var covers = List<CoverModel>()
    dynamic var name: String! = ""
    dynamic var search_count: Double = 0
    dynamic var search_count_timestamp: String?

    override func mapping(map: Map) {
        super.mapping(map)
        
        avatar <- map["avatar"]
        avatar_id <- map["avatar_id"]
        name <- map["name"]
        search_count <- map["search_count"]
        search_count_timestamp <- map["search_count_timestamp"]
        covers <- map["covers"]
        
    }
}
