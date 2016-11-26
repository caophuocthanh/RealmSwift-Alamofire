//
//  UserModel.swift
//  RealmManager
//
//  Created by Cao Phuoc Thanh on 10/28/16.
//  Copyright © 2016 Cao Phuoc Thanh. All rights reserved.
//

import Foundation
import RealmSwift

class UserModel: BaseModel {
    
    dynamic var nickname    : String   = ""
    dynamic var slug        : String   = ""
    dynamic var facebook_id : String   = ""
    dynamic var email       : String? = nil
    dynamic var avatar      : FileModel?
    dynamic var cover       : FileModel?
    dynamic var record_count: Int = 0
    dynamic var listen_count: Int = 0

}
