//
//  ArtistModel.swift
//  RealmManager
//
//  Created by Cao Phuoc Thanh on 11/3/16.
//  Copyright © 2016 Cao Phuoc Thanh. All rights reserved.
//

import Foundation
import RealmSwift

class ArtistModel: BaseModel {
    dynamic var name: String = ""
    dynamic var search_count: Int = 0
    var covers = List<CoverModel>()
    dynamic var avatar: FileModel?
}
