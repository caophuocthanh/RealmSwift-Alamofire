//
//  FileModel.swift
//  RealmManager
//
//  Created by Cao Phuoc Thanh on 10/28/16.
//  Copyright © 2016 Cao Phuoc Thanh. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class FileModel: BaseModel {
    
    dynamic var tone_color: String? = nil
    dynamic var url: String? = nil
    
    override func mapping(map: Map) {
        super.mapping(map)
        
        tone_color <- map["tone_color"]
        url <- map["url"]
    }
    
}
