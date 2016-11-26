//
//  SingerModel.swift
//  RealmManager
//
//  Created by Cao Phuoc Thanh on 11/3/16.
//  Copyright © 2016 Cao Phuoc Thanh. All rights reserved.
//

import Foundation
import RealmSwift

class SingerModel: BaseModel {
    
    dynamic var avatar: FileModel?
    dynamic var avatar_id: Int = 0
    let covers = List<CoverModel>()
    dynamic var name: String! = ""
    dynamic var search_count: Double = 0
    dynamic var search_count_timestamp: String?

}
