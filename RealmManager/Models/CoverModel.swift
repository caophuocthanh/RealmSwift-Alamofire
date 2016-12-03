//
//  CoverModel.swift
//  RealmManager
//
//  Created by Cao Phuoc Thanh on 11/3/16.
//  Copyright © 2016 Cao Phuoc Thanh. All rights reserved.
//

import Foundation
import RealmSwift

class CoverModel: ZModel {
    
    dynamic var artist_id   : Int = 0
    dynamic var cover       : FileModel?
}
